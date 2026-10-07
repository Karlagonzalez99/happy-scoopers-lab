WITH addresses AS (
    SELECT * FROM {{ ref('stg_oltp_addresses') }}
),
cities AS (
    SELECT * FROM {{ ref('stg_oltp_cities') }}
),
provinces AS (
    SELECT * FROM {{ ref('stg_oltp_provinces') }}
),
countries AS (
    SELECT * FROM {{ ref('stg_oltp_countries') }}
),

aplanamiento AS (
    SELECT 
        -- 1. Llave de negocio
        a.address_id,
        
        -- 2. Atributos de dirección
        a.address_line1,
        a.address_line2,
        a.postal_code,
        
        -- 3. Atributos de ciudad
        c.city_name AS city,
        c.population AS city_population,
        
        -- 4. Atributos de provincia
        p.province_code,
        p.province_name AS province,
        p.population AS province_population,
        
        -- 5. Atributos de país y continente
        co.country_code,
        co.country_name AS country,
        co.formal_name AS country_formal_name,
        co.population AS country_population,
        co.continent,
        co.region,
        co.subregion
    FROM addresses a
    LEFT JOIN cities c ON a.city_id = c.city_id
    LEFT JOIN provinces p ON c.province_id = p.province_id
    LEFT JOIN countries co ON p.country_id = co.country_id
),
miembro_desconocido AS (
    -- Fila manual para datos huérfanos o nulos
    SELECT 
        -1 AS location_key,
        -1 AS address_id,
        'Desconocido' AS address_line1,
        NULL AS address_line2,
        'N/A' AS postal_code,
        'Desconocido' AS city,
        NULL::bigint AS city_population, -- Nota: casteado a bigint como pide Postgres
        'N/A' AS province_code,
        'Desconocido' AS province,
        NULL::bigint AS province_population,
        'N/A' AS country_code,
        'Desconocido' AS country,
        'Desconocido' AS country_formal_name,
        NULL::bigint AS country_population,
        'Desconocido' AS continent,
        'Desconocido' AS region,
        'Desconocido' AS subregion
),
-- CTE final que une los datos reales con el miembro desconocido
modelo_final AS (
    -- Primero seleccionamos el miembro desconocido
    SELECT * FROM miembro_desconocido
    
    UNION ALL
    
    -- Luego seleccionamos los datos reales aplanados y les generamos su llave subrogada
    SELECT 
        -- Opción recomendada si usas dbt_utils:
        {{ dbt_utils.generate_surrogate_key(['address_id']) }} AS location_key,
        
        -- Si dbt_utils te da error porque no está instalado, comenta la línea de arriba 
        -- y descomenta la de abajo usando MD5 nativo de Postgres:
        -- md5(address_id::text) AS location_key,
        
        *
    FROM aplanamiento
)

-- El ÚNICO SELECT final que dbt ejecutará para construir la vista o tabla
SELECT * FROM modelo_final
{{ config(materialized='table') }}

WITH date_spine AS (
    SELECT generate_series(
        '2015-01-01'::date,
        '2030-12-31'::date,
        '1 day'::interval
    )::date AS full_date
),
calculated AS (
    SELECT
        TO_CHAR(full_date, 'YYYYMMDD')::int AS date_key,
        full_date,
        EXTRACT(YEAR FROM full_date)::int AS year,
        EXTRACT(QUARTER FROM full_date)::int AS quarter,
        EXTRACT(MONTH FROM full_date)::int AS month,
        TO_CHAR(full_date, 'TMMonth') AS month_name,
        EXTRACT(DAY FROM full_date)::int AS day,
        EXTRACT(ISODOW FROM full_date)::int AS day_of_week,
        TO_CHAR(full_date, 'TMDay') AS day_name,
        CASE
            WHEN EXTRACT(ISODOW FROM full_date) IN (6, 7) THEN 'Fin de semana'
            ELSE 'Entre semana'
        END AS day_type
    FROM date_spine
),
unknown_member AS (
    SELECT
        -1 AS date_key,
        NULL::date AS full_date,
        -1 AS year,
        -1 AS quarter,
        -1 AS month,
        'N/A' AS month_name,
        -1 AS day,
        -1 AS day_of_week,
        'N/A' AS day_name,
        'N/A' AS day_type
)
SELECT * FROM unknown_member
UNION ALL
SELECT * FROM calculated
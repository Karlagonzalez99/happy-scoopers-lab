version: 2

models:
  - name: dim_date
    description: >
      Dimensión Fecha (calendario). Una fila por día.
      Incluye una fila "desconocido" (date_key = -1) para hechos sin fecha.
    columns:
      - name: date_key
        description: "Llave única de la fecha (YYYYMMDD). -1 = desconocido."
        data_tests:
          - unique
          - not_null
      - name: day_type
        description: "'Entre semana' | 'Fin de semana' | 'N/A'."
        data_tests:
          - accepted_values:
              arguments:
                values: ['Entre semana', 'Fin de semana', 'N/A']
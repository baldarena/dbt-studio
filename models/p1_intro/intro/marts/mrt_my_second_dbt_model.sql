select *
from {{ ref('stg_my_first_dbt_model') }}
where id = 1

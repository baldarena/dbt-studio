SELECT
         id AS id_customer
       , first_name AS des_first_name
       , last_name AS des_last_name
FROM 
       {{ source('jaffle_shop', 'customers') }}
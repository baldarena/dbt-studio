SELECT
         id AS id_order
       , user_id AS id_customer
       , order_date AS dt_order
       , status AS sts_order
FROM 
       {{ source('jaffle_shop', 'orders') }}
WITH 

  orders AS(
    SELECT * 
    FROM {{ ref('stg_jaffle_shop__orders') }}
)
, customers AS(
    SELECT * 
    FROM {{ ref('stg_jaffle_shop__customers') }}
)
, payments AS (
    SELECT * 
    FROM {{ ref('stg_stripe__payments') }}
)
, payments_metrics AS (
    SELECT
              p.id_payment
            , CASE WHEN p.sts_payment = 'success' THEN p.dt_payment END AS dt_succeeded_payment
            , CASE WHEN p.sts_payment = 'success' THEN p.dt_payment END AS dt_succeeded_transaction
            , CASE WHEN p.sts_payment = 'success' THEN 1 END AS flg_succeeded_transaction
            , CASE WHEN p.sts_payment = 'fail' THEN 1 END AS flg_failed_transaction
            , CASE WHEN p.sts_payment = 'success' THEN p.vl_payment END AS vl_succeeded_transaction
            , CASE WHEN p.sts_payment = 'fail' THEN p.vl_payment END AS vl_failed_transaction    
    FROM
            payments p
)

, int_payments_metrics AS (
    SELECT
              p.id_payment
            , o.id_order
            , o.dt_order
            , o.sts_order
            , c.id_customer
            , c.des_first_name
            , c.des_last_name
            , p.des_payment_method
            , p.sts_payment
            , p.dt_payment
            , pm.dt_succeeded_payment
            , p.vl_payment
            , pm.dt_succeeded_transaction  
            , pm.flg_succeeded_transaction
            , pm.flg_failed_transaction
            , pm.vl_succeeded_transaction
            , pm.vl_failed_transaction 
    FROM
            payments p
    LEFT JOIN
            payments_metrics pm USING (id_payment)        
    LEFT JOIN
            orders o USING (id_order)
    LEFT JOIN
            customers c USING (id_customer)
)

SELECT *
FROM int_payments_metrics
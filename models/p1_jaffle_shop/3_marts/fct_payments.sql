WITH

payments_metrics AS (
    SELECT *
    FROM {{ ref('int_payment_metrics') }}
)

, fct_payments AS (
    SELECT DISTINCT
              pm.id_payment
            , pm.id_order
            , pm.id_customer
            , pm.des_payment_method
            , pm.sts_payment
            , pm.dt_payment
            , pm.vl_payment 
    FROM
            payments_metrics pm
)

SELECT *
FROM fct_payments
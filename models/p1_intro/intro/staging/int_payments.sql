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

, int_payments AS (
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
            , p.vl_payment
    FROM
            payments p
    LEFT JOIN
            orders o USING (id_order)
    LEFT JOIN
            customers c USING (id_customer)
)

SELECT *
FROM int_payments
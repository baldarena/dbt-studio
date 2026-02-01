{% set payment_methods = ['bank_transfer','credit_card','coupon','gift_card'] %}

WITH

payments_orders AS (
    SELECT *
    FROM {{ ref('int_payments') }}
)

, fct_payments AS (
    SELECT DISTINCT
              po.id_payment
            , po.id_order
            , po.id_customer
            , po.vl_payment_received
            , po.dt_payment
            , po.sts_payment
            , po.des_payment_method
    FROM
            payments_orders po
)

SELECT *
FROM fact_payments
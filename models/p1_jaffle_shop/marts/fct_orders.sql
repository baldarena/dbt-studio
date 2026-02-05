WITH

orders_metrics AS (
    SELECT *
    FROM {{ ref('int_orders_metrics') }}
)

, fct_orders AS (
    SELECT
              om.id_order
            , om.id_customer
            , om.dt_order
            , om.sts_order
            , om.qt_orders
            , om.qt_payment_methods
            , om.dt_last_succeeded_payment
            , om.qt_succeeded_transactions
            , om.vl_succeeded_transactions
            , om.qt_failed_transactions
            , om.vl_wavg_failed_transactions
    FROM 
            orders_metrics om
)

SELECT *
FROM fct_orders
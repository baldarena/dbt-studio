WITH

payments_metrics AS (
    SELECT *
    FROM {{ ref('int_payment_metrics') }}
)
, orders_metrics AS(
    SELECT
              pm.id_order
            , pm.id_customer
            , pm.dt_order
            , pm.sts_order
            , COUNT(pm.id_order) AS qt_orders
            , COUNT(DISTINCT pm.flg_succeeded_transaction) AS qt_payment_methods
            , MAX(pm.dt_succeeded_payment) AS dt_last_succeeded_payment
            , SUM(pm.flg_succeeded_transaction) AS qt_succeeded_transactions
            , SUM(pm.vl_succeeded_transaction) AS vl_succeeded_transactions
            , SUM(pm.flg_failed_transaction) AS qt_failed_transactions
            , SAFE_DIVIDE(
                  SUM(POWER(pm.vl_failed_transaction, 2)) 
                , SUM(pm.vl_failed_transaction)
              ) AS vl_wavg_failed_transactions
    FROM
            payments_metrics pm
    GROUP BY
              pm.id_order
            , pm.id_customer
            , pm.dt_order
            , pm.sts_order
)

, int_orders_metrics AS (
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

SELECT * FROM int_orders_metrics
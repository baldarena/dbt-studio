WITH

payments_metrics AS (
    SELECT *
    FROM {{ ref('int_payment_metrics') }}
)
, order_status_metrics AS(
    SELECT
              pm.id_customer
            , pm.sts_order
            , COUNT(pm.id_order) AS qt_orders
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
              pm.sts_order
            , pm.id_customer
)

, int_order_status_metrics AS (
    SELECT
              om.id_customer
            , om.sts_order
            , om.qt_orders
            , om.qt_succeeded_transactions
            , om.vl_succeeded_transactions
            , om.qt_failed_transactions
            , om.vl_wavg_failed_transactions
    FROM 
            order_status_metrics om
)

SELECT * FROM int_order_status_metrics
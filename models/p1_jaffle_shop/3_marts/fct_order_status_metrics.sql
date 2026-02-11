WITH order_status_metrics AS (
    SELECT * FROM {{ ref('int_order_status_metrics') }}
)

, fct_order_status_metrics AS (
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

SELECT * FROM fct_order_status_metrics
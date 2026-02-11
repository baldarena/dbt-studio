WITH

payments_metrics AS (
    SELECT *
    FROM {{ ref('int_payment_metrics') }}
)
, payment_method_preferred AS (
    SELECT
              pm.id_customer
            , pm.des_payment_method
            , COUNT(pm.id_payment) AS qt_transactions
            , SAFE_DIVIDE(
                  COUNT(pm.id_payment)
                , SUM(COUNT(pm.id_payment)) OVER(PARTITION BY pm.id_customer)
              ) AS pct_share_payment_method  
    FROM
            payments_metrics pm
    GROUP BY
              pm.id_customer
            , pm.des_payment_method
    QUALIFY 
            ROW_NUMBER() 
            OVER(PARTITION BY pm.id_customer ORDER BY COUNT(pm.id_payment) DESC) = 1
)
, customers_payments_metrics AS (
    SELECT
              pm.id_customer
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
              pm.id_customer
)
, customers_core_metrics AS(
    SELECT
              pm.id_customer
            , pm.des_first_name
            , pm.des_last_name
            , COUNT(DISTINCT pm.id_order) AS qt_orders
            , COUNT(DISTINCT IF(pm.sts_order = 'returned', pm.id_order, NULL)) AS qt_orders_returned
            , MIN(pm.dt_order) AS dt_first_order
            , MAX(pm.dt_order) AS dt_last_order
            , SUM(pm.vl_succeeded_transaction) AS vl_lifetime
            , SAFE_DIVIDE(
                  SUM(pm.vl_succeeded_transaction)
                , COUNT(DISTINCT pm.id_order)
              ) AS vl_avg_ticket
    FROM
            payments_metrics pm
    GROUP BY
              pm.id_customer
            , pm.des_first_name
            , pm.des_last_name
)

, int_customers_metrics AS (
    SELECT
              cm.id_customer
            , cm.des_first_name
            , cm.des_last_name
            , cm.qt_orders
            , cm.qt_orders_returned
            , cm.dt_first_order
            , cm.dt_last_order
            , cm.vl_lifetime
            , cm.vl_avg_ticket
            , pm.des_payment_method AS des_payment_method_preferred
            , pm.pct_share_payment_method AS pct_share_payment_method_preferred
            , cp.qt_succeeded_transactions
            , cp.vl_succeeded_transactions
            , cp.qt_failed_transactions
            , cp.vl_wavg_failed_transactions 
    FROM
            customers_core_metrics cm
    LEFT JOIN
            customers_payments_metrics cp USING (id_customer)
    LEFT JOIN
            payment_method_preferred pm USING (id_customer)
)

SELECT * FROM int_customers_metrics
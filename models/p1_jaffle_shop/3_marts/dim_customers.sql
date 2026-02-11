WITH 

customers AS (
    SELECT * FROM {{ ref('stg_jaffle_shop__customers') }}
)
, customers_metrics AS (
    SELECT *
    FROM {{ ref('int_customers_metrics') }}
)

, dim_customers AS (
    SELECT
              c.id_customer
            , c.des_first_name
            , c.des_last_name
            , cm.qt_orders
            , cm.qt_orders_returned
            , cm.dt_first_order
            , cm.dt_last_order
            , cm.vl_lifetime
            , cm.vl_avg_ticket
            , cm.des_payment_method_preferred
            , cm.pct_share_payment_method_preferred
            , cm.qt_succeeded_transactions
            , cm.vl_succeeded_transactions
            , cm.qt_failed_transactions
            , cm.vl_wavg_failed_transactions 
    FROM
            customers c
    LEFT JOIN
            customers_metrics cm USING (id_customer)
)

SELECT * 
FROM dim_customers
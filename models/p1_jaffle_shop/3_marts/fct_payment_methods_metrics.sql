WITH payment_methods_metrics AS (
    SELECT * FROM {{ ref('int_payment_methods_metrics') }}
)

, fct_payment_methods_metrics AS (
    SELECT
              pm.id_customer
            , pm.des_payment_method
            , pm.qt_succeeded_transactions
            , pm.vl_succeeded_transactions
            , pm.qt_failed_transactions
            , pm.vl_wavg_failed_transactions
    FROM 
            payment_methods_metrics pm
)

SELECT * FROM fct_payment_methods_metrics
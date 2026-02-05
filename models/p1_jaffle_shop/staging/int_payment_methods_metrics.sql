WITH

  payments_metrics AS (
    SELECT *
    FROM {{ ref('int_payment_metrics') }}
)
, payment_methods_metrics AS (
    SELECT
              pm.id_customer
            , pm.des_payment_method
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
            , pm.des_payment_method
)

, int_payment_methods_metrics AS (
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

SELECT * FROM int_payment_methods_metrics
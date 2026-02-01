{% set payment_methods = ['bank_transfer','credit_card','coupon','gift_card'] %}

WITH

core_payments AS (
    SELECT *
    FROM {{ ref('int_payments') }}
)
, orders_payments_pivoted AS (
    SELECT 
              cp.id_order

            --columns 'qt_transactions', 'qt_failed_transactions' and 'vl_payment' per payment method
            , {% for payment_method in payment_methods %}
                  COUNTIF(cp.payment_method = {{ payment_method }} AND cp.sts_payment = 'success') AS qt_succeeded_transactions_{{ payment_method }}
                , COUNTIF(cp.payment_method = {{ payment_method }} AND cp.sts_payment = 'fail') AS qt_failed_transactions_{{ payment_method }}  
                , SUM(
                    CASE WHEN cp.payment_method = {{ payment_method }} AND cp.sts_payment = 'success' THEN cp.vl_payment_received ELSE 0 END
                  ) AS vl_payment_received_{{ payment_method }}       
              {% endfor %}
    FROM
            core_payments cp
    GROUP BY ALL
)

, int_orders AS(
    SELECT
              cp.id_order
            , cp.id_customer
            , cp.des_first_name
            , cp.des_last_name
            , cp.sts_order
            , cp.dt_order

            , COUNTIF(cp.sts_payment = 'success') AS qt_succeeded_transactions
            , MAX(op.qt_succeeded_transactions_bank_transfer) AS qt_succeeded_transactions_bank_transfer
            , MAX(op.qt_succeeded_transactions_credit_card) AS qt_succeeded_transactions_credit_card
            , MAX(op.qt_succeeded_transactions_coupon) AS qt_succeeded_transactions_coupon
            , MAX(op.qt_succeeded_transactions_gift_card) AS qt_succeeded_transactions_gift_card

            , SUM(CASE WHEN cp.sts_payment = 'success' THEN cp.vl_payment_received END) AS vl_payment_received
            , MAX(op.vl_payment_received_bank_transfer) AS vl_payment_received_bank_transfer 
            , MAX(op.vl_payment_received_credit_card) AS vl_payment_received_credit_card
            , MAX(op.vl_payment_received_coupon) AS vl_payment_received_coupon
            , MAX(op.vl_payment_received_gift_card) AS vl_payment_received_gift_card

            , COUNT(DISTINCT IF(cp.sts_payment = 'success', cp.payment_method, NULL)) AS qt_payment_methods
            , MAX(CASE WHEN cp.sts_payment = 'success' THEN dt_payment END) AS dt_last_payment

            , COUNTIF(cp.sts_payment = 'fail') AS qt_failed_transactions
            , MAX(op.qt_failed_transactions_bank_transfer) AS qt_failed_transactions_bank_transfer 
            , MAX(op.qt_failed_transactions_credit_card) AS qt_failed_transactions_credit_card
            , MAX(op.qt_failed_transactions_coupon) AS qt_failed_transactions_coupon
            , MAX(op.qt_failed_transactions_gift_card) AS qt_failed_transactions_gift_card
    FROM
            orders_payments_pivoted op
    LEFT JOIN
            core_payments cp USING (id_order)
    GROUP BY ALL
)

SELECT * FROM int_orders
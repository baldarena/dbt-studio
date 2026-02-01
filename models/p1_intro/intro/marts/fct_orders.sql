WITH

core_orders AS (
    SELECT *
    FROM {{ ref('int_orders') }}
)

, fct_orders AS (
    SELECT DISTINCT
              co.id_order
            , co.id_customer
            , co.sts_order
            , co.dt_order

            , co.qt_succeeded_transactions
            , co.qt_succeeded_transactions_bank_transfer
            , co.qt_succeeded_transactions_credit_card
            , co.qt_succeeded_transactions_coupon
            , co.qt_succeeded_transactions_gift_card

            , co.vl_payment_received
            , co.vl_payment_received_bank_transfer
            , co.vl_payment_received_credit_card
            , co.vl_payment_received_coupon
            , co.vl_payment_received_gift_card

            , co.qt_payment_methods
            , co.dt_last_payment

            , co.qt_failed_transactions
            , co.qt_failed_transactions_bank_transfer
            , co.qt_failed_transactions_credit_card
            , co.qt_failed_transactions_coupon
            , co.qt_failed_transactions_gift_card
    FROM
            core_orders co
)

SELECT *
FROM fct_orders
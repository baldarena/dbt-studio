{% set order_status = ['completed','placed','shipped','returned', 'return_pending'] %}

WITH 

core_orders AS (
    SELECT *
    FROM {{ ref('int_orders') }}
)
, order_status_pivoted AS (
    SELECT
              co.id_customer

            --columns 'qt_orders' e 'vl_payment_received' per order status
             {% for status_order in order_status %}
                , COUNTIF(co.sts_order = '{{ status_order }}') AS qt_orders_{{ status_order }}
                , SUM(
                    CASE WHEN co.sts_order = '{{ status_order }}' THEN co.vl_payment_received ELSE 0 END
                  ) AS vl_payment_received_{{ status_order }}_orders       
              {% endfor %}

    FROM
            core_orders co
    GROUP BY
            co.id_customer
)

, dim_customers AS (
    SELECT
              co.id_customer
            , COUNT(co.id_order) AS qt_orders
            , MIN(co.dt_order) AS dt_first_order
            , MAX(co.dt_order) AS dt_last_order

            , MAX(op.qt_orders_completed) AS qt_orders_completed
            , MAX(op.qt_orders_placed) AS qt_orders_placed
            , MAX(op.qt_orders_shipped) AS qt_orders_shipped
            , MAX(op.qt_orders_return_pending) AS qt_orders_return_pending
            , MAX(op.qt_orders_returned) AS qt_orders_returned

            , MAX(op.vl_payment_received_completed_orders) AS vl_payment_received_completed_orders
            , MAX(op.vl_payment_received_placed_orders) AS vl_payment_received_placed_orders
            , MAX(op.vl_payment_received_shipped_orders) AS vl_payment_received_shipped_orders
            , MAX(op.vl_payment_received_return_pending_orders) AS vl_payment_received_return_pending_orders
            , MAX(op.vl_payment_received_returned_orders) AS vl_payment_received_returned_orders

            , SUM(co.qt_succeeded_transactions) AS qt_succeeded_transactions
            , SUM(co.qt_succeeded_transactions_bank_transfer) AS qt_succeeded_transactions_bank_transfer
            , SUM(co.qt_succeeded_transactions_credit_card) AS qt_succeeded_transactions_credit_card
            , SUM(co.qt_succeeded_transactions_coupon) AS qt_succeeded_transactions_coupon
            , SUM(co.qt_succeeded_transactions_gift_card) As qt_succeeded_transactions_gift_card

            , SUM(co.vl_payment_received) AS vl_payment_received
            , SUM(co.vl_payment_received_bank_transfer) AS vl_payment_received_bank_transfer
            , SUM(co.vl_payment_received_credit_card) AS vl_payment_received_credit_card
            , SUM(co.vl_payment_received_coupon) AS vl_payment_received_coupon
            , SUM(co.vl_payment_received_gift_card) AS vl_payment_received_gift_card

            , SUM(co.qt_failed_transactions) AS qt_failed_transactions
            , SUM(co.qt_failed_transactions_bank_transfer) AS qt_failed_transactions_bank_transfer
            , SUM(co.qt_failed_transactions_credit_card) AS qt_failed_transactions_credit_card
            , SUM(co.qt_failed_transactions_coupon) AS qt_failed_transactions_coupon
            , SUM(co.qt_failed_transactions_gift_card) AS qt_failed_transactions_gift_card
    FROM
            core_orders co
    LEFT JOIN
            order_status_pivoted op USING (id_customer)
    GROUP BY 
              co.id_customer
)

SELECT * 
FROM dim_customers
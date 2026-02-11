SELECT
          id AS id_payment
        , orderid AS id_order
        , paymentmethod AS des_payment_method
        , status AS sts_payment
        , amount / 100 AS vl_payment
        , created AS dt_payment
        , _batched_at AS dt_hr_payment_load
FROM 
        {{ source('stripe', 'payments') }}
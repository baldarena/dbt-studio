SELECT
          id AS id_payment,
        , orderid AS id_order
        , paymentmethod AS des_payment_method
        , status AS sts_payment
        , amount AS vl_payment_received
        , created AS dt_payment
        , _batchedat AS dt_hr_payment_load
FROM 
        `phb-raw-zone.stripe.payments`
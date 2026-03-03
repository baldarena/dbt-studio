SELECT
          id_order
        , SUM(vl_payment)
FROM
        {{ ref('stg_stripe__payments') }}
GROUP BY
        id_order
HAVING SUM(vl_payment) < 0
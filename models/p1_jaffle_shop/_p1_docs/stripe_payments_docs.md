# keys

{% docs pk_id_payment %}
    Primary key for payments source/table, one unique id per transactions (attempt or Installment).
{% enddocs %}

{% docs fk_id_payment %}
    Foreign key for the payments table.
{% enddocs %}


# dates

{% docs dt_payment %}
    Datetime in which each transaction was registered (be it an attempt or an installment).
{% enddocs %}


# classifications

{% docs sts_payment %}
    Payment/transaction situation; Possible values: success, fail (an ATTEMPT if it fails, an INSTALLMENT if it succeeds).
{% enddocs %}

{% docs payment_methods %}
    
One of the following values: 

| method         | definition                                                                   |
|----------------|------------------------------------------------------------------------------|
| credit_card    | Attempt/Installment paid by credit card                                      |
| gift_card      | Promotional gift cards adquired or originated from reimbursements or rewards |
| coupon         | Vouchers origined from last minute promotions or inventory burn              |
| bank_transfer  | Attempt/Installment paid via bank transfer or pix                            |

{% enddocs %}


# amounts

{% docs vl_payment %}
    Transaction value (be it an attempt or an installment).
{% enddocs %}


# aggregations

{% docs qt_payment_methods %}
    Amount of payment transactions (#) with 'success' status per payment method.
{% enddocs %}

{% docs qt_succeeded_transactions %}
    Amount of payment transactions (#) with 'success' status per table min grain level (payment, order or customer).
{% enddocs %}

{% docs vl_succeeded_transactions %}
    Amount of payment transactions ($) with 'success' status per table min grain level (payment, order or customer).
{% enddocs %}

{% docs qt_failed_transactions %}
    Amount of payment transactions (#) with 'fail' status per table min grain level (payment, order or customer).
{% enddocs %}

{% docs vl_wavg_failed_transactions %}
    Weighted Average of payment transactions ($) with 'fail' status per table min grain level (payment, order or customer).
    Why Weighted Average? 
        - Because multiple failed transactions per min grain represent retries and cannot be summed, otherwise metrics would be inflated;
        - Also, it normalizes value discrepancies per min grain level (e.g. avg > (100 + 900)/2 = 500 | wavg > 100 * 100/1000 + 900 * 900/1000 = 820).
{% enddocs %}

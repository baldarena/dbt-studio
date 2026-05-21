{% docs order_status %}
    
One of the following values: 

| status         | definition                                       |
|----------------|--------------------------------------------------|
| placed         | Order placed, not yet shipped                    |
| shipped        | Order has been shipped, not yet been delivered   |
| completed      | Order has been received by customers             |
| return pending | Customer indicated they want to return this item |
| returned       | Item has been returned                           |

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


# customers fields

{% docs first_name %}
    customers' given name
{% enddocs %}

{% docs last_name %}
    customers' family name
{% enddocs %}



# aggregated amounts

{% docs qt_succeeded_transactions %}
    Amount of payment transactions (#) with 'success' status per table min grain level (payment, order or customer)
{% enddocs %}

{% docs vl_succeeded_transactions %}
    Amount of payment transactions ($) with 'success' status per table min grain level (payment, order or customer)
{% enddocs %}

{% docs qt_failed_transactions %}
    Amount of payment transactions (#) with 'fail' status per table min grain level (payment, order or customer)
{% enddocs %}

{% docs vl_wavg_failed_transactions %}
    Weighted Average of payment transactions ($) with 'fail' status per table min grain level (payment, order or customer).
    Why Weighted Average? 
        - Because multiple failed transactions per min grain represent retries and cannot be summed, otherwise metrics would be inflated;
        - Also, it normalizes value discrepancies per min grain level (e.g. avg > (100 + 900)/2 = 500 | wavg > 100 * 100/1000 + 900 * 900/1000 = 820)
{% enddocs %}

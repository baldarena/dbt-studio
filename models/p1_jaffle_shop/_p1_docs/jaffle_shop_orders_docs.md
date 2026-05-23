# keys

{% docs pk_id_order %}
    Primary key for orders source/table, one unique id per order.
{% enddocs %}

{% docs fk_id_order %}
    Foreign key for the orders table.
{% enddocs %}


# dates

{% docs dt_order %}
    Datetime in which each order was registered.
{% enddocs %}


# classifications

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


# aggregations

{% docs qt_orders %}
    Amount of orders (#) (regardless of its status) per table min grain level (payment, order or customer).
{% enddocs %}

{% docs dt_last_succeeded_payment %}
    Datetime of most recent succeeded transaction/installment per table min grain level (order or customer).
{% enddocs %}
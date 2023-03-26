select
    id as payment_id,
    orderid as order_id,
    paymentmethod as payment_method,
    {{ kobo_to_naira("amount") }} as amount,
    status,
    created
from {{ source('paystack', 'payments') }}

{{ config(materialized="ephemeral") }}

{%- set payment_methods = ["coupon", "gift_card", "credit_card", "bank_transfer"] -%}

with
    orders as (select * from {{ ref("stg_jaffle_shop__orders") }}),

    payments as (select * from {{ ref("stg_paystack__payments") }}),

    order_payments as (
        select
            order_id,

            {% for method in payment_methods -%}
            sum(
                case when payment_method = '{{ method }}' then amount end
            ) as {{ method }}_amount,
            {% endfor %}

            sum(case when status = 'success' then amount end) as total_amount,
        from payments
        group by order_id
    )

select *
from order_payments

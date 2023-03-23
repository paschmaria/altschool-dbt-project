{{ config(materialized="table") }}

with
    customers as (
        select *
        from {{ ref('stg_jaffle_shop__customers') }}
    ),

    orders as (
        select *
        from {{ ref('stg_jaffle_shop__orders') }}
    ),

    payments as (
        select *
        from {{ ref('stg_payments__payments') }}
    ),

    customer_orders as (
        select
            customer_id,
            min(order_date) as first_order_date,
            max(order_date) as last_order_date,
            count(order_id) as number_of_orders
        from orders
        group by customer_id
    ),

    customer_payments as (
        select orders.customer_id, sum(amount) as total_amount
        from payments
        left join orders on payments.order_id = orders.order_id
        group by orders.customer_id
    ),

    final as (
        select
            customers.customer_id,
            customers.first_name,
            customers.last_name,
            customer_orders.first_order_date,
            customer_orders.last_order_date,
            customer_orders.number_of_orders,
            customer_payments.total_amount
        from customers
        left join customer_orders on customer_orders.customer_id = customers.customer_id
        left join
            customer_payments on customer_payments.customer_id = customers.customer_id
    )

select *
from final

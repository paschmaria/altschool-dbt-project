{{ config(materialized="table") }}

with
    orders as (select * from {{ ref("stg_jaffle_shop__orders") }}),

    order_payments as (select * from {{ ref("int_order_payments_pivoted") }}),

    final as (select * from orders left join order_payments using (order_id))

select *
from final

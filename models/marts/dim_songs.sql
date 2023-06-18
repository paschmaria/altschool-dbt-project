{{ config(materialized="table") }}

select * from {{ ref("stg_jaffle_shop__songs") }}

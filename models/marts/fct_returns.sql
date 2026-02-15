{{ config(
    materialized='table'
) }}

with returns as (
    select
        r.return_date,
        r.return_quantity,
        t.region,
        t.country,
        t.continent,
        p.product_sku,
        p.product_name,
        p.model_name,
        p.product_description,
        p.product_cost,
        p.product_price

       
    from {{ ref('stg_returns') }} r
    join {{ ref('stg_territory') }} t
        on r.territory_key = t.territory_key
    join {{ ref('stg_product') }} p
        on r.product_key = p.product_key
)

select *
from returns

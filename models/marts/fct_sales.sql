{{ config(
    materialized='incremental',
    incremental_strategy='merge'
) }}

with source_data as (
    select
        s.order_date,
        s.stock_date,
        s.order_number, 
        s.customer_key,
        s.order_quantity,
        p.product_sku,
        p.product_name,
        p.model_name,
        p.product_description,
        p.product_color,
        p.product_size,
        p.product_style,
        p.product_cost,
        p.product_price,
        t.region,
        t.country,
        t.continent,
        ps.subcategory_name,
        pc.category_name
    from {{ ref('stg_sales') }} s
    join {{ ref('stg_product') }} p
        on s.product_key = p.product_key
    join {{ ref('stg_territory') }} t
        on s.territory_key = t.territory_key
    join {{ ref('stg_product_subcategories') }} ps
        on p.product_subcategory_key = ps.product_subcategory_key
    join {{ ref('stg_product_categories') }} pc
        on ps.product_category_key = pc.product_category_key
)

select *
from source_data
{% if is_incremental() %}
where order_date > (select coalesce(max(order_date), '1900-01-01') from {{ this }})
{% endif %}

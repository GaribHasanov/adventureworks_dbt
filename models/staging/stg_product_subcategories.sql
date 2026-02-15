{{ config(materialized='view') }}

select
    productsubcategorykey   as product_subcategory_key,
    productcategorykey      as product_category_key,
    trim(subcategoryname)   as subcategory_name
from {{ source('adventureworks_app', 'adventureworks_product_subcategories_lookup') }}

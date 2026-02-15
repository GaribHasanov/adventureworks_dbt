{{ config(materialized='view') }}

select
    productcategorykey as product_category_key,
    trim(categoryname) as category_name
from {{ source('adventureworks_app', 'adventureworks_product_categories_lookup') }}

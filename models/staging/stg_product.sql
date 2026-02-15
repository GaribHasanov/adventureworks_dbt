{{ config(materialized='view') }}

select
    productkey             as product_key,
    productsku             as product_sku,
    trim(productname)      as product_name,         -- removes leading/trailing spaces
    trim(modelname)        as model_name,           -- removes leading/trailing spaces
    trim(productdescription) as product_description, -- removes leading/trailing spaces
    trim(productcolor)     as product_color,        -- removes leading/trailing spaces
    trim(productsize)      as product_size,         -- removes leading/trailing spaces
    trim(productstyle)     as product_style,        -- removes leading/trailing spaces
    productcost            as product_cost,
    productprice           as product_price,
    productsubcategorykey  as product_subcategory_key
from {{ source('adventureworks_app', 'adventureworks_product_lookup') }}

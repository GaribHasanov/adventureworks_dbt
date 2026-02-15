{{ config(materialized='view') }}

select
    orderdate      as order_date,      -- date when the order was placed
    stockdate      as stock_date,      -- date when the product was stocked
    ordernumber    as order_number,    -- unique order number
    productkey     as product_key,     -- foreign key to product
    territorykey   as territory_key,   -- foreign key to territory
    customerkey    as customer_key,
    orderquantity  as order_quantity
from {{ source('adventureworks_app', 'adventureworks_sales_data_2022') }}

{{ config(materialized='view') }}

select
    returndate       as return_date,       -- date of the return
    returnquantity   as return_quantity,   -- quantity of items returned
    territorykey     as territory_key,     -- foreign key to territory
    productkey       as product_key        -- foreign key to product
from {{ source('adventureworks_app', 'adventureworks_returns_data') }}

{{ config(materialized='view') }}

select
    salesterritorykey as territory_key,
    region,
    country,
    continent
from {{ source('adventureworks_app', 'adventureworks_territory_lookup') }}
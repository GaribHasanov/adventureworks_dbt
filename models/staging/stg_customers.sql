{{ config(materialized='view') }}

select
    customerkey          as customer_key,
trim(coalesce(prefix, '')) || ' ' || trim(coalesce(firstname, '')) || ' ' || trim(coalesce(lastname, '')) AS full_name,
 -- concat prefix + first + last
    maritalstatus        as marital_status,
    gender,
    lower(emailaddress)  as email_address,
    annualincome         as annual_income,
    occupation,
    homeowner
from {{ source('adventureworks_app', 'adventureworks_customer_lookup') }}
where customerkey is not null
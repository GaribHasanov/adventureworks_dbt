{{ config(
    materialized='incremental',
    unique_key='dim_customer_id',
    incremental_strategy='merge'

) }}

-- Source data
with source_data as (
    select
        customer_key,
        full_name,             -- concatws edilmiş prefix + firstname + lastname
        marital_status,
        gender,
        email_address,
        annual_income,
        occupation,
        homeowner,
        current_timestamp as valid_from,
        null::timestamp as valid_to,
        1 as is_current
    from {{ ref('stg_customers') }}
),

{% if is_incremental() %}
-- Incremental run: köhnə aktiv record-ları source ilə müqayisə et
updated_records as (
    select 
        t.dim_customer_id,
        t.customer_key,
        t.full_name,
        t.marital_status,
        t.gender,
        t.email_address,
        t.annual_income,
        t.occupation,
        t.homeowner,
        t.valid_from,
        t.valid_to,
        t.is_current
    from {{ this }} t
    join source_data s
      on t.customer_key = s.customer_key
     and t.is_current = 1
     and (
         t.full_name       <> s.full_name
      or t.marital_status <> s.marital_status
      or t.gender         <> s.gender
      or t.email_address  <> s.email_address
      or t.annual_income  <> s.annual_income
      or t.occupation     <> s.occupation
      or t.homeowner      <> s.homeowner
     )
)
{% else %}
-- İlk run: cədvəl hələ yoxdur → updated_records boş
updated_records as (
    select
        null::bigint as dim_customer_id,
        customer_key,
        full_name,
        marital_status,
        gender,
        email_address,
        annual_income,
        occupation,
        homeowner,
        valid_from,
        null::timestamp as valid_to,
        0 as is_current
    from source_data
    limit 0
)
{% endif %}

-- Final cədvəl: köhnə record-ları close et + yeni record-ları insert et
select *
from (

    -- Yeni və dəyişmiş record-lar
    select
        nextval('dim_customer_seq') as dim_customer_id,  -- Surrogate key
        customer_key,
        full_name,
        marital_status,
        gender,
        email_address,
        annual_income,
        occupation,
        homeowner,
        valid_from,
        valid_to,
        is_current
    from source_data

    union all

    -- Köhnə record-lar (close edilmiş)
    select
        dim_customer_id,
        customer_key,
        full_name,
        marital_status,
        gender,
        email_address,
        annual_income,
        occupation,
        homeowner,
        valid_from,
        current_timestamp as valid_to,
        0 as is_current
    from updated_records

) final

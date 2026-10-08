{{
    config(
        tags = ['token'],
        alias = var('token_name_var')~'_activity_per_day'
    )
}}

with token_transfers as (
    select * from {{ ref('stg_token_transfers') }}
)

select 
    t.date,
    t.token_address,
    {{ conversion('t.value', var('token_decimals_var')) }} as total_value
from token_transfers as t
where lower(t.token_address) = '{{ var('token_address_var') }}'
group by t.date, t.token_address
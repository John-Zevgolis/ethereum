{{
    config(
        tags = ['stablecoin']
    )
}}

with token_transfers as (
    select * from {{ ref('stg_token_transfers') }}
),
stablecoins as (
    select * from {{ ref('raw_stablecoins') }}
)

select 
    t.date,
    t.token_address,
    s.type,
    s.symbol,
    {{ conversion('t.value', 's.decimals') }} as total_usd_value
from token_transfers as t
left join stablecoins as s
on t.token_address = s.contract_address
where s.contract_address is not null
group by t.date, t.token_address, s.type, s.symbol
{{
    config(
        materialized='incremental',
        incremental_strategy='append',
        on_schema_change='fail'
    )
}}

with transactions as (
    select * from {{ ref('stg_transactions') }}
),
token_transfers as (
    select * from {{ ref('stg_token_transfers') }}
)

select 
    t.hash, 
    t.block_number,
    t.date,
    t.from_address,
    t.to_address,
    t.value,
    t.receipt_contract_address,
    t.input,
    coalesce(tt.token_transfer_count, 0) as token_transfer_count,
    case
        when t.receipt_contract_address != '' then 'contract_creation'
        when tt.transaction_hash is not null then 'token_transfer'
        when t.input = '0x' and t.value > 0 then 'plain_eth_transfer'
        else 'other'
    end as transaction_category
from transactions as t
left join (
    select 
        transaction_hash,
        count(*) as token_transfer_count
    from token_transfers
    group by transaction_hash
) as tt 
on t.hash = tt.transaction_hash

{% if is_incremental() %}
    where date >= (select max(date) from {{ this }})
{% endif %}
{{
    config(
        materialized = 'table',
        tags = ['daily']
    )
}}

with transactions_enriched as (
    select * from {{ ref('int_transactions_enriched') }}
)

select
    date,
    transaction_category,
    count(*) as tx_count,
    {{ conversion('value', '18') }} as sum_eth_value
from transactions_enriched
group by
date,
transaction_category
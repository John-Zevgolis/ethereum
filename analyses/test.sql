{# {{ codegen.generate_source(schema_name='dev', database_name='eth', generate_columns=True, include_data_types=False) }} #}

{# {{ codegen.generate_model_yaml(['stg_transactions', 'int_transactions_enriched', 'fct_stablecoin_activity_per_day']) }} #}

{# select
{{ dbt_utils.star(from=ref('int_transactions_enriched', except=['new_field'], quote_identifiers=False, prefix='STG_')) }}
from {{ ref('int_transactions_enriched') }} #}

{# {{ audit_helper.compare_relations(source('eth', 'contracts'), source('eth', 'contracts_clone')) }} #}
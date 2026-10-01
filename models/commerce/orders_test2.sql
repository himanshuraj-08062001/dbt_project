-- models/test/select_columns_test.sql
{{
  config(
    materialized = 'table'
  )
}}

select
  {{ select_columns_2(
      ref('orders'),
      table_alias = 'o',
      include_columns=['order_id', 'status', 'customer.name'],
      column_aliases={'customer.name': 'customer_name'}
  ) }}
from {{ ref('orders') }} o


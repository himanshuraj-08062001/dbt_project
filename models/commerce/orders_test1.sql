-- In a model
select
  {{ select_columns(
       ref('orders'),
       table_alias = 'o',
       include_columns=['order_id', 'status', 'amount'],
       column_aliases={'amount': 'total_amount'}
  ) }}
from {{ ref('orders') }} o

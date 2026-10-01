-- orders.sql
{{
  config(
    materialized = 'table'
  )
}}

{{ generate_orders_dataset() }}
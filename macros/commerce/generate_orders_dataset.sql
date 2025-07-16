{% macro generate_orders_dataset(row_count=10000) %}
  {#
    Generates realistic e-commerce data with proper Snowflake syntax
    and per-row randomness for all fields
  #}
  
  with generated_data as (
    select
      row_number() over (order by seq4()) as order_id,
      dateadd('day', -mod(abs(hash(seq4())), 365), current_date) as order_date,
      
      -- Random status
      case mod(abs(hash(seq4())), 6)
        when 0 then 'pending'
        when 1 then 'processing'
        when 2 then 'shipped'
        when 3 then 'delivered'
        when 4 then 'returned'
        else 'cancelled'
      end as status,
      
      -- Random amount
      (10 + mod(abs(hash(seq4())), 500) + (mod(abs(hash(seq8())), 100)/100.0)::numeric(10,2)) as amount,
      
      -- Random customer
      object_construct(
        'name', case mod(abs(hash(seq4())), 10)
          when 0 then 'John Smith'
          when 1 then 'Maria Garcia'
          when 2 then 'David Johnson'
          when 3 then 'Sarah Williams'
          when 4 then 'James Brown'
          when 5 then 'Emily Davis'
          when 6 then 'Robert Wilson'
          when 7 then 'Jennifer Martinez'
          when 8 then 'Michael Anderson'
          else 'Lisa Taylor'
        end,
        
        'email', lower(
          case mod(abs(hash(seq4())), 10)
            when 0 then 'john'
            when 1 then 'maria'
            when 2 then 'david'
            when 3 then 'sarah'
            when 4 then 'james'
            when 5 then 'emily'
            when 6 then 'robert'
            when 7 then 'jennifer'
            when 8 then 'michael'
            else 'lisa'
          end
        ) || '@example.com',
        
        'address', 
        (mod(abs(hash(seq4())), 1000) + 1 || ' ' ||
        case mod(abs(hash(seq4())), 5)
          when 0 then 'Main'
          when 1 then 'Oak'
          when 2 then 'Pine'
          when 3 then 'Maple'
          else 'Cedar'
        end || ' St., ' ||
        case mod(abs(hash(seq4())), 5)
          when 0 then 'New York'
          when 1 then 'Los Angeles'
          when 2 then 'Chicago'
          when 3 then 'Houston'
          else 'Phoenix'
        end || ' ' ||
        (mod(abs(hash(seq4())), 90000) + 10000)
      )) as customer,
      
      -- Random items
      array_construct(
        object_construct(
          'sku', case mod(abs(hash(seq4())), 5)
            when 0 then 'PROD-001'
            when 1 then 'PROD-002'
            when 2 then 'PROD-003'
            when 3 then 'PROD-004'
            else 'PROD-005'
          end,
          'quantity', (mod(abs(hash(seq4())), 5) + 1),
          'price', case mod(abs(hash(seq4())), 5)
            when 0 then 89.99
            when 1 then 59.50
            when 2 then 199.99
            when 3 then 24.99
            else 12.99
          end
        ),
        object_construct(
          'sku', case mod(abs(hash(seq8())), 5)
            when 0 then 'PROD-001'
            when 1 then 'PROD-002'
            when 2 then 'PROD-003'
            when 3 then 'PROD-004'
            else 'PROD-005'
          end,
          'quantity', (mod(abs(hash(seq8())), 5) + 1),
          'price', case mod(abs(hash(seq8())), 5)
            when 0 then 89.99
            when 1 then 59.50
            when 2 then 199.99
            when 3 then 24.99
            else 12.99
          end
        )
      ) as items
    from table(generator(rowcount => {{ row_count }}))
) 
  select * from generated_data
{% endmacro %}
with payments as (
    select * from {{ ref('stg_stripe__payments') }}
),
pivoted as (
    select order_id,
        {%-set payment_methods = ['credit_card', 'coupon', 'bank_transfer', 'gift_card']%}
        {%- for payment in payment_methods%}
            sum(case when payment_method = '{{payment}}' then amount else 0 end ) as {{payment}}_amount {% if not loop.last%},            
            {%-endif%}
        {%-endfor%}
    from payments
    where status = 'success'
    group by 1
)
select * from pivoted
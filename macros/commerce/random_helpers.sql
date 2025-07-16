{% macro random_choice(list) %}
  {# Returns a random element from a list #}
  {% set random_index = range(0, list|length)|random %}
  {{ return(list[random_index]) }}
{% endmacro %}

{% macro random_date(days_back) %}
  {# Returns a random date within the last X days #}
  dateadd('day', -floor(uniform(0, {{ days_back }}, random()))::int, current_date)
{% endmacro %}
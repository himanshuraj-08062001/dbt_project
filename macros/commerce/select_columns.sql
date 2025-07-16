{% macro select_columns(table_ref, table_alias, include_columns=none, exclude_columns=none, column_aliases=none) %}
  {#
    Parameters:
      - table_ref: The table reference (e.g., ref('orders'))
      - include_columns: List of columns to include (if none, include all)
      - exclude_columns: List of columns to exclude
      - column_aliases: Dictionary of {original_name: new_name}
  #}
  {%- set all_columns = adapter.get_columns_in_relation(table_ref) -%}
  
  {%- set selected_columns = [] -%}

  {%- for column in all_columns -%}
        {%- set should_include = (
            (include_columns is none or column.name | lower in include_columns) and 
            (exclude_columns is none or column.name | lower not in exclude_columns)
        ) -%}
        {%- if should_include -%}
            {%- set alias = column_aliases.get(column.name | lower, column.name) -%}
            {%- do selected_columns.append(table_alias~ '.' ~ column.name ~ ' as ' ~ alias) -%}
        {%- endif -%}
  {%- endfor -%}

  {{ return(selected_columns | join(',\n    ')) }}
{% endmacro %}

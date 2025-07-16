{%- macro select_columns_2(table_ref, table_alias, include_columns=none, exclude_columns=none, column_aliases=none) -%}
    {%- set all_columns= adapter.get_columns_in_relation(table_ref) -%}
    {%- set selected_columns=[] -%}

    {# determine which columns to process #}
    {%- set column_to_process = include_columns if include_columns is not none
            else all_columns | map(attribute= 'name') -%}
    
    {%- for column in column_to_process -%}
        {%- set column_lower = column | lower -%}
        {%- set is_excluded = exclude_columns is not none
                and column_lower  in (exclude_columns | map('lower') | list) -%}
        {%- if not is_excluded -%}
            {%- if '.' in column_lower -%}
                {# Handle nested fields #}
                {%- set path_parts = column.split('.') -%}
                {%- set base_column = path_parts[0] -%}
                {%- set nested_path = path_parts[1:] | join('.') -%}
                {# Check if the base column is available in all_columns #}
                {%- set base_column_exists = all_columns | selectattr('name', 'equalto', base_column | upper) | list | length > 0 -%}

                {%- if base_column_exists  -%}
                    {%- set alias = column_aliases.get(column_lower, column | replace('.', '_')) -%}
                    {%- do selected_columns.append(table_alias ~ '.' ~ base_column ~ ':' ~ nested_path ~ ' as ' ~ alias) -%}
                {%- else -%}
                    {{ log("Warning: Base Column '" ~ base_column ~"' not found for the nested field '" ~ column ~ "'", info=true) }}
                {%- endif -%}

            {%- else -%}
                {# handle normal columns #}
                {# check if the the column exists #}
                {%- set column_exists = all_columns | selectattr('name', 'equalto', column | upper) | list | length > 0 -%}
                {%- if column_exists -%}
                    {%- set alias = column_aliases.get(column_lower, column) -%}
                    {%- do selected_columns.append(table_alias ~ '.' ~ column_lower ~ ' as ' ~ alias) -%}
                {%- else -%}
                    {{ log("Warning: Column '" ~ column ~ "' not found in the table", info=true)}}
                {%- endif -%}
            {%- endif -%}
        {%- endif -%}
    {%- endfor -%}
    {{ return(selected_columns | join(',\n  '))}}
{%- endmacro -%}

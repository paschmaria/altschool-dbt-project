{% macro kobo_to_naira(column_name) %}
    cast({{ column_name }} / 100 as numeric)
{% endmacro %}

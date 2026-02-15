{% macro restart_dim_customer_seq() %}
  {% if is_full_refresh() %}
    ALTER SEQUENCE dim_customer_seq RESTART WITH 1;
  {% endif %}
{% endmacro %}

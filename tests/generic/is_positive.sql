{% test is_positive(model, column_name) %}

with validation as (

    select
       {{ column_name }}  as testColumn

    from {{ model }}

    where testColumn < 0

)

select *
from validation

{% endtest %}
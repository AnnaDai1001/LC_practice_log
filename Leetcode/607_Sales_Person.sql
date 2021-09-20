# Find sales_id that have orders with 'RED' company
# Exclude these sales_id, get the name

select name
from salesperson
where sales_id not in
(select o.sales_id
from orders o, company c
where o.com_id = c.com_id and c.name = 'RED')
;

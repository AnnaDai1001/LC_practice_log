select customer_number
from
(select customer_number, count(*) as cnt
from orders
group by customer_number) tbl
order by cnt desc
limit 1
;




select customer_number
from orders
group by customer_number
order by count(*) desc
limit 1
;


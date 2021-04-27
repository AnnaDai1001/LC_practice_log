select f_1 as id, count(distinct f_2) as num
from(
select requester_id as f_1, accepter_id as f_2
from request_accepted
union all
select accepter_id as f_1, requester_id as f_2
from request_accepted
) tbl
group by f_1
order by num desc
limit 1
;

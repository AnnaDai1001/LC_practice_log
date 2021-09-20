
select request_at as day, round(sum(if(status="cancelled by driver" or status="cancelled by client", 1, 0))/count(*), 2) as "Cacellation Rate"
from trips
where client_id not in (select user_id from users where banned = "Yes")
and driver_id not in (select user_id from users where banned = "Yes")
and request_at between '2003-10-01' and '2003-10-03'
group by request_at
;

select request_at as day, round(sum(CASE WHEN status LIKE "cancelled%" THEN 1 ELSE 0 END)/count(*), 2) as "Cacellation Rate"
from 
(select * from trips
where client_id not in (select user_id from users where banned = "Yes")
and driver_id not in (select user_id from users where banned = "Yes")
and request_at between '2003-10-01' and '2003-10-03') as new_trips
group by request_at
;



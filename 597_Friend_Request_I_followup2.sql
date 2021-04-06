# Follow-up 2: return the cumulative accept rate for every day

select round(
            count(distinct acc.accepter_id, acc.requester_id) /  count(distinct req.sender_id, acc.send_to_id)
            2) as rate, date_table.dates
from 
request_accepted acc,
friend_request req,
(select accept_date as dates from request_accepted
  union
 select request_date as dates from friend_request
 order by dates) as date_table
 where acc.accepte_date <= date_table.dates and req.request_date <= date_table.dates
 group by date_table.dates
 ;

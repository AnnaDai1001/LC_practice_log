# accept rate for each month
# requests each month
# accepts each month
# divided after joining; denominator = 0?; ifnull?

select if(req_tbl.req=0, 0.00,round(acc_tbl.acc/req_tbl.req,2)) as accept_rate, req_tbl.req_month as month
from
(select count(distinct sender_id, send_to_id) as req, left(request_date, 7) as req_month
from friend_request
group by left(request_date, 7)) req_tbl
join
(select count(distinct requester_id, accepter_id) as acc, left(accept_date, 7) as acc_month
from request_accepted
group by left(accept_date, 7)) acc_tbl
on req_tbl.req_month = acc_tbl.acc_month
;

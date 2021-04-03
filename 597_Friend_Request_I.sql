select ifnull(count(distinct sender_id, send_to_id) / count(distinct requester_id, accepter_id), 0) as accept_rate
from friend_request, request_accepted

# follow-up
# write a query for the rate each month

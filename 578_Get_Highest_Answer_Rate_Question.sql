select question_id as survey_log
from
(select question_id, sum(case when action='answer' then 1 else 0 end)/sum(case when action='show' then 1 else 0 end) as ans_rate from survey_log group by question_id) as tbl
order by ans_rate desc
limit 1
;

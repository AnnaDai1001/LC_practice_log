
select name
from candidate c, 
(select candidateid
        from vote
        group by candidateid
        order by count(*) desc
        limit 1) winner
where c.id = winner.candidateid

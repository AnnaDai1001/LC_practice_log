select name
from employee as e1
inner join
(select e2.managerid as m_id
from employee e2
group by e2.managerid
having count(*) >= 5
) m
on e1.id=m.m_id
;

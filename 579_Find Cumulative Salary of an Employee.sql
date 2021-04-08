select e1.id, max(e2.month) as month, sum(e2.salary) as salary
from employee e1, employee e2
where e1.id=e2.id and e2.month between (e1.month-3) and (e1.month-1)
group by e1.id, e1.month
order by id, month desc
;

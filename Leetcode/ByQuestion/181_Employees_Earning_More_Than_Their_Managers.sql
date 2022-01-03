select e.name as employee
from employee e, employee m
where e.managerid is not null and e.managerid=m.id and e.salary>m.salary
;

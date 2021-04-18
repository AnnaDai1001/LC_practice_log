select avg(n.number) median
from numbers n
where n.frequency >= abs((select sum(n1.frequency) from numbers n1 where n.number >= n1.number) - (select sum(n2.frequency) from numbers n2 where n.number <= n2.number))
;

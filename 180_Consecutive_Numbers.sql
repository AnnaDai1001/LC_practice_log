select t1.num as consecutivenums
from logs t1, logs t2, logs t3
where t1.id=t2.id-1 and t1.id=t3.id-2 and t1.num=t2.num and t2.num=t3.num
;

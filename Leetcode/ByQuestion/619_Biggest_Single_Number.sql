select num
from number
group by num
having count(num)=1
order by num desc
limit 1
;

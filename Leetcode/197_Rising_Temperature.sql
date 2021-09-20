select d2.id
from weather d1, weather d2
where to_days(d2.recorddate)-to_days(d1.recorddate)=1 and d2.temperature > d1.temperature
;

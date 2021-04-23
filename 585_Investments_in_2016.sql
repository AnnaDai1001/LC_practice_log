select sum(i.tiv_2016) as tiv_2016
from insurance i
where i.tiv_2015 in (select tiv_2015 from insurance group by tiv_2015 having count(pid) > 1) 
and i.lat in (select lat from insurance group by lat having count(pid) = 1)
and i.lon in (select lon from insurance group by lon having count(pid) = 1)
;

select sum(i.tiv_2016) as tiv_2016
from insurance i
where 1 = (select count(*) from insurance i2 where i2.lat=i.lat and i2.lon=i.lat) 
and 1 < (select count(*) from insurance i3 where i3.tiv_2015=i.tiv_2015) 
;

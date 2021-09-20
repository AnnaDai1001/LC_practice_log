select a.follower, count(distinct a.followee) as num
from follow a, follow b
where a.follower = b.followee
group by a.follower
order by a.follower;

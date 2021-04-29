select abs(min(a.x-b.x)) as shortest
from point a, point b
where a.x != b.x
;

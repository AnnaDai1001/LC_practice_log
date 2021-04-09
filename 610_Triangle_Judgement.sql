select x, y, z, 
case when x+y<=z or x+z<=y or x+z<=y then "No" else "Yes" end as triangle
from triangle
;

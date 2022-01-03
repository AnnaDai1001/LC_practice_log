select max(America) as America, max(Asia) as America, max(Europe) as Europe
from
(
select case when continent='America' then @r1 = @r1 +1
            when continent='Asia' then @r2 = @r2 +1
            when continent='Europe' then @r3 = @r3 +1 end id,
       case when continent='America' then name else NULL end America,
       case when continent='Asia' then name else NULL end Asia,
       case when continent='Europe' then name else NULL end Europe
from student, (select @r1:=0, @r2:=0, @r3:=0) as ids
order by name
) as tempTable
group by id
;

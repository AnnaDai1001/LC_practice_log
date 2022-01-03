select t.id,
if(isnull(t.p_id), 'root', if(t.id in (select p_id from tree), 'inner', 'leaf')) as type
from tree t
;

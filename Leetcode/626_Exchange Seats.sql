SELECT 
(CASE
WHEN seat.id=0 THEN seat.id-1
WHEN seat.id<>0 AND seat.id=(SELECT COUNT(*) FROM seat) THEN seat.id
ELSE seat.id+1 END) AS id, student
FROM seat
ORDER BY id
;

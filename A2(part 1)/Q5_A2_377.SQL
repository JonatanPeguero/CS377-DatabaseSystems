-- THIS WORK WAS MY (OUR) OWN WORK. IT WAS WRITTEN WITHOUT CONSULTING
-- WORK WRITTEN BY OTHER STUDENTS OR COPIED FROM ONLINE RESOURCES.
-- _jonatan_peguero_
SELECT v."bill.id", COUNT(v."cosponsor") AS numcosponsors, b."bill.str"
FROM vote v
JOIN bill b ON v."bill.id" = b."bill.id"  
WHERE v."cosponsor" = 1 
GROUP BY v."bill.id", b."bill.str"
ORDER BY numcosponsors DESC
LIMIT 1;
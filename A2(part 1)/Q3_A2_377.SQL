-- THIS WORK WAS MY (OUR) OWN WORK. IT WAS WRITTEN WITHOUT CONSULTING
-- WORK WRITTEN BY OTHER STUDENTS OR COPIED FROM ONLINE RESOURCES.
-- _jonatan_peguero_
SELECT "bonica.cid", "most.recent.contributor.name" AS name, "contributor.type" AS type, "amount.2022" AS totalAmount
FROM contributor
WHERE "amount.2022" IS NOT NULL
ORDER BY "amount.2022" DESC
LIMIT 10;

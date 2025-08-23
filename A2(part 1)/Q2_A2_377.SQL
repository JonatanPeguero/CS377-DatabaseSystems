-- THIS WORK WAS MY (OUR) OWN WORK. IT WAS WRITTEN WITHOUT CONSULTING
-- WORK WRITTEN BY OTHER STUDENTS OR COPIED FROM ONLINE RESOURCES.
-- _jonatan_peguero_SELECT "bonica.rid", name, cycle, "num.givers" AS numDonors
FROM recipient
WHERE "num.givers" = (SELECT MAX("num.givers") FROM recipient)
ORDER BY name;
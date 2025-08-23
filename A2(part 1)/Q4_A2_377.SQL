-- THIS WORK WAS MY (OUR) OWN WORK. IT WAS WRITTEN WITHOUT CONSULTING
-- WORK WRITTEN BY OTHER STUDENTS OR COPIED FROM ONLINE RESOURCES.
-- _jonatan_peguero_
SELECT "bonica.cid", "most.recent.contributor.name" AS name, "contributor.type" AS type, 
SUM("amount.1980" + "amount.1982" + "amount.1984" + "amount.1986" + "amount.1988" + "amount.1990" + "amount.1992" + "amount.1994" + "amount.1996" + "amount.1998" + "amount.2000" + "amount.2002" + "amount.2004" + "amount.2006" + "amount.2008" + "amount.2010" + "amount.2012" + "amount.2014" + "amount.2016" + "amount.2018" + "amount.2020" + "amount.2022") AS totalAmount
FROM contributor
WHERE (
    "amount.1980" IS NOT NULL OR "amount.1982" IS NOT NULL OR 
    "amount.1984" IS NOT NULL OR "amount.1986" IS NOT NULL OR 
    "amount.1988" IS NOT NULL OR "amount.1990" IS NOT NULL OR 
    "amount.1992" IS NOT NULL OR "amount.1994" IS NOT NULL OR 
    "amount.1996" IS NOT NULL OR "amount.1998" IS NOT NULL OR 
    "amount.2000" IS NOT NULL OR "amount.2002" IS NOT NULL OR 
    "amount.2004" IS NOT NULL OR "amount.2006" IS NOT NULL OR 
    "amount.2008" IS NOT NULL OR "amount.2010" IS NOT NULL OR 
    "amount.2012" IS NOT NULL OR "amount.2014" IS NOT NULL OR 
    "amount.2016" IS NOT NULL OR "amount.2018" IS NOT NULL OR 
    "amount.2020" IS NOT NULL OR "amount.2022" IS NOT NULL
)
GROUP BY "bonica.cid", "most.recent.contributor.name", "contributor.type"
ORDER BY totalAmount DESC
LIMIT 10;
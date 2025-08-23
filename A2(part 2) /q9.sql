
-- THIS WORK WAS MY (OUR) OWN WORK. IT WAS WRITTEN WITHOUT CONSULTING
-- WORK WRITTEN BY OTHER STUDENTS OR COPIED FROM ONLINE RESOURCES.
-- Jonatan Peguero 
set search_path to dimeDB;
create view indRep as
select distinct "bonica.rid"
from Recipient
where party = '328';

delete from Recipient
where "bonica.rid" in (select "bonica.rid" from indRep);

delete from Vote
where "bonica.rid" in (select "bonica.rid" from indRep);

delete from Contribution
where "bonica.rid" in (select "bonica.rid" from indRep);

delete from Contribution
where "bonica.cid" in (select "bonica.rid" from indRep);

delete from Contributor
where "bonica.cid" in (select "bonica.rid" from indRep);

drop view indRep;

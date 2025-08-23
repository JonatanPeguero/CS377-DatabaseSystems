-- THIS WORK WAS MY (OUR) OWN WORK. IT WAS WRITTEN WITHOUT CONSULTING
-- WORK WRITTEN BY OTHER STUDENTS OR COPIED FROM ONLINE RESOURCES.
-- Jonatan Peguero 
set search_path to dimeDB;
drop table if exists influence;
create table influence (
	"bill.id" varchar references bill("bill.id"),
	"vote.id" varchar references vote("vote.id"),
	"dw.economy" float default 0 check ("dw.economy" >= 0 and "dw.economy" <=1),
	"dw.environment" float default 0 check ("dw.environment" >= 0 and "dw.environment" <=1),
	"dw.foreign.policy" float default 0 check ("dw.foreign.policy" >= 0 and "dw.foreign.policy" <=1),
	"dw.womens.issues" float default 0 check ("dw.womens.issues" >= 0 and "dw.womens.issues" <=1),
	"dw.guns" float default 0 check ("dw.guns" >= 0 and "dw.guns" <=1),
	"dw.healthcare" float default 0 check ("dw.healthcare" >= 0 and "dw.healthcare" <=1),
	primary key("bill.id", "vote.id")
	
);

insert into influence ("bill.id", "vote.id", "dw.environment", "dw.foreign.policy")
select v."bill.id", v."vote.id", 0.3, 0.7
from vote v 
where v."bill.id" in (
	select b."bill.id"
	from bill b
	join vote v2 on b."bill.id" = v2."bill.id"
	group by b."bill.id"
	having sum(v2."cosponsor") = (
		select max(cosponsors)
		from (select sum(v3."cosponsor") as cosponsors from vote v3 group by v3."bill.id") as temp
		)
	);

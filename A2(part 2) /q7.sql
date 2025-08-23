
-- THIS WORK WAS MY (OUR) OWN WORK. IT WAS WRITTEN WITHOUT CONSULTING
-- WORK WRITTEN BY OTHER STUDENTS OR COPIED FROM ONLINE RESOURCES.
-- Jonatan Peguero 
set search_path to dimeDB;

create or replace view top3 as (
select "bonica.cid", "most.recent.contributor.name" as name, ("amount.1980"+"amount.1982"+"amount.1984"+"amount.1986"+"amount.1988"+ "amount.1990"+"amount.1992"+"amount.1994" + "amount.1996"+ "amount.1998"+"amount.2000"+"amount.2002"+"amount.2004"+"amount.2006"+"amount.2008"+"amount.2010"+"amount.2012"+"amount.2014"+"amount.2016"+"amount.2018"+"amount.2020"+"amount.2022") as totalAmount
from contributor 
order by totalAmount 
desc limit 3);

create or replace view totalCont as (
select "bonica.cid",
		"bonica.rid", 
		"recipient.name",
		sum(amount) as totCont
from Contribution 
where "bonica.cid" in (select "bonica.cid" from top3)
	and "recipient.type" = 'CAND'
group by "bonica.cid", "bonica.rid", "recipient.name");

create or replace view maxCont as (
select "bonica.cid",
		max(totCont) as maxCont
from totalCont
group by "bonica.cid");

select t3."bonica.cid", t3.name, tc."bonica.rid", tc."recipient.name", tc.totCont as max_amount
from top3 t3 
left join maxCont mc on t3."bonica.cid" = mc."bonica.cid"
left join totalCont tc on mc."bonica.cid" = tc."bonica.cid" and mc.maxCont = tc.totCont
order by t3.name asc, maxCont desc;
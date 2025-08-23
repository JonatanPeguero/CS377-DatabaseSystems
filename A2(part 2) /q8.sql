
-- THIS WORK WAS MY (OUR) OWN WORK. IT WAS WRITTEN WITHOUT CONSULTING
-- WORK WRITTEN BY OTHER STUDENTS OR COPIED FROM ONLINE RESOURCES.
-- Jonatan Peguero
set search_path to dimeDB;

select * from (
select 'federal' as level,
		"contributor.gender",
		count(*),
		avg(amount) as average_amount
from contribution 
where seat like 'federal:%'
	and "contributor.gender" in ('M', 'F')
group by "contributor.gender"

union

select 'state' as level,
		"contributor.gender",
		count(*),
		avg(amount) as average_amount
from contribution
where seat like 'state:%'
	and "contributor.gender" in ('M', 'F')
group by "contributor.gender"

union

select 'local' as level, 
		"contributor.gender", 
		count(*), 
		avg(amount) as average_amount
from contribution
where seat like 'local:%' 
	and "contributor.gender" in ('M', 'F')
group by "contributor.gender"
) temp
order by level desc, "contributor.gender" asc;
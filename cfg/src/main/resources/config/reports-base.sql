/*
 *  report  base views
 */

/* select method,(select regexp_matches(url,'^(https?:\/\/)?(www\.)?([a-zA-Z0-9\.\-\_]*)')) 
    from squid_events where id>87000; */

drop function if exists getHostNameFromUrl(varchar) cascade;
create or replace function getHostNameFromUrl(url varchar) 
returns varchar 
as
$$
declare 
    result varchar(2028)='';
begin
    /*
	http://www.postgresql.org/docs/9.3/interactive/functions-matching.html#FUNCTIONS-POSIX-REGEXP
	It is possible to force regexp_matches() to always return one row by using a sub-select; 
	this is particularly useful in a SELECT target list when you want all rows returned, even non-matching ones
	https://en.wikipedia.org/wiki/Hostname
    */

    result=(select regexp_matches(url,'^(https?:\/\/)?(www\.)?([a-zA-Z0-9\.\-\_]*)'))[3];

    if char_length(result)>0  then
	return trim(result);
    end if;

    return 'request error';    
end;
$$ 
language plpgsql;

drop materialized view if exists vr_reports_base cascade;
create materialized view vr_reports_base
as
select id,
date_trunc('day',request_date) as day,
date_trunc('week',request_date) as week, 
date_trunc('month',request_date) as month,
date_part('year',request_date) as year,
gethostnamefromurl(url) as url 
from squidevents
with no data;

refresh materialized view vr_reports_base;




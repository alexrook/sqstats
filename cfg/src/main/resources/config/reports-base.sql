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

drop table if exists sitegroup cascade;
create table sitegroup 
(id int primary key,
 regex varchar(33) unique,
 name varchar(150) unique,
 description varchar(350)
);

drop function if exists getGroupHostNameFromSite(varchar) cascade;
create or replace function getGroupHostNameFromSite(site varchar) 
returns varchar 
as
$$
declare 
    result varchar;
begin
    
    select name from sitegroup into result
        where site ~ regex fetch first row only;

    if char_length(result)>0  then
	return trim(result);
    end if;

    return site;    
end;
$$ 
language plpgsql;



drop table if exists reportsbase cascade;
create table reportsbase
(
    id int unique,
    day timestamp,
    week timestamp, 
    month timestamp,
    year double precision,
    site varchar(150),
    sitegroup varchar(150)
);

drop materialized view if exists vr_reportsbase cascade;
create materialized view vr_reportsbase
as
select a.*,b.day,b.week,b.month,b.year,b.site,b.sitegroup
from
squidevents a, reportsbase b
where a.id=b.id;




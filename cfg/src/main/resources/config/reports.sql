/*
 *  report  views
 */


/*итоги за день */
drop /*MATERIALIZED*/ view if exists vr_day_sums;
create or replace /*MATERIALIZED*/ view vr_day_sums
as
select date_trunc('day',request_date) as day,/* дата */
	sum(duration) as duration,/* общее время соединений */
        sum(bytes) as bytes, /* общая сумма байтов */
	count(client_host) as conn_count /*всего соединений за один день*/
    from squidevents group by day;



/*итоги за день по клиентам*/
drop /*MATERIALIZED*/ view if exists vr_day_sums_client ;
create or replace /*MATERIALIZED*/ view vr_day_sums_client
as 
select day,
	b.address, -- ip
	b.name, -- hostname
	b.description,-- client host description
	duration,bytes,conn_count
from
(select  date_trunc('day',request_date) as day,/* дата */
	client_host,
	sum(duration) as duration,/* общее время соединения  за день для клиента */
        sum(bytes) as bytes, /* сумма байтов для клиента */
	count(client_host) as conn_count /*всего соединений за день для определенного клиента*/
    from squidevents
    group by day,client_host) as a,
    clienthost b
    where a.client_host=b.id;

--todo: month year

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

/*итоги за день по клиентам и сайтам*/
drop /*MATERIALIZED*/ view if exists vr_day_sums_client_site ;
create or replace /*MATERIALIZED*/ view vr_day_sums_client_site
as
select day,
	b.address, -- ip
	b.name, -- hostname
	b.description,-- client host description
	site,
	duration,bytes,conn_count
from
(select date_trunc('day',request_date) as day,/* дата */
	client_host,/* клиент */
	gethostnamefromurl(url) as site, -- сайт
	sum(duration) as duration,/* общее время соединения  за день для клиента по сайтам*/
        sum(bytes) as bytes, /* сумма байтов для клиента по сайтам*/
	count(client_host) as conn_count /*всего соединений за день для определенного клиента и сайта*/
    from squidevents group by day,client_host,site) as a,
    clienthost b
    where b.id=a.client_host;

/*итоги за день по сайтам*/
drop /*MATERIALIZED*/ view if exists vr_day_sums_site ;
create or replace /*MATERIALIZED*/ view vr_day_sums_site
as
select  date_trunc('day',request_date) as day,/* дата */
	gethostnamefromurl(url) as site, -- сайт
	sum(duration) as duration,/* общее время соединений  за день*/
        sum(bytes) as bytes, /* сумма байтов*/
	count(client_host) as conn_count /*всего соединений за день для определенного сайта*/
    from squidevents group by day,site;





 

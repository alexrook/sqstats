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
    from squid_events group by day;



/*итоги за день по клиентам*/
drop /*MATERIALIZED*/ view if exists vr_day_sums_client ;
create or replace /*MATERIALIZED*/ view vr_day_sums_client
as
select date_trunc('day',request_date) as day,/* дата */
	client_host,/* клиент */
	sum(duration) as duration,/* общее время соединения  за день для клиента */
        sum(bytes) as bytes, /* сумма байтов для клиента */
	count(client_host) as conn_count /*всего соединений за день для определенного клиента*/
    from squid_events group by day,client_host;

--todo: month year

/* select method,(select regexp_matches(url,'^(https?:\/\/)?(www\.)?([a-zA-Z0-9\.\-\_]*)')) 
    from squid_events where id>87000; */

drop function if exists getHostName(varchar) cascade;
create or replace function getHostName(url varchar) 
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
select date_trunc('day',request_date) as day,/* дата */
	client_host,/* клиент */
	gethostname(url) as site, -- сайт
	sum(duration) as duration,/* общее время соединения  за день для клиента */
        sum(bytes) as bytes, /* сумма байтов для клиента */
	count(client_host) as conn_count /*всего соединений за день для определенного клиента*/
    from squid_events group by day,client_host,site;







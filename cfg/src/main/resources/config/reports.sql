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


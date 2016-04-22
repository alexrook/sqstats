/*
 *  report  views
 */


/*итоги за день */
drop MATERIALIZED view if exists vr_day_sums cascade;
create MATERIALIZED view vr_day_sums
as
select date_trunc('day',request_date) as day,/* дата */
	sum(duration) as duration,/* общее время соединений */
        sum(bytes) as bytes, /* общая сумма байтов */
	count(client_host) as conn_count /*всего соединений за один день*/
    from squidevents group by day;

---xml version 
drop view if exists vr_xml_day_sums ;
create or replace view vr_xml_day_sums
as
select a.*,xmlforest(xmlforest(a.day,a.duration,a.bytes,a.conn_count) as row) as row from vr_day_sums a;

/*итоги за день по клиентам*/
drop MATERIALIZED view if exists vr_day_sums_client cascade;
create MATERIALIZED view vr_day_sums_client
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

---xml version
drop view if exists vr_xml_day_sums_client cascade;
create or replace view vr_xml_day_sums_client
as
select a.*,xmlforest(xmlforest(a.day,a.address,a.name,a.description,
	a.duration,a.bytes,a.conn_count) as row) as row
        from vr_day_sums_client a;

/*итоги за день по клиентам и сайтам*/
drop MATERIALIZED view if exists vr_day_sums_client_site cascade;
create MATERIALIZED view vr_day_sums_client_site
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

---xml version
drop view if exists vr_xml_day_sums_client_site;
create or replace view vr_xml_day_sums_client_site
as
select a.*,
xmlforest(xmlforest(a.day,a.address,a.name,a.description,
	    a.site,a.duration,a.bytes,a.conn_count) as row) as row
        from vr_day_sums_client_site a;


/*итоги за день по сайтам*/
drop MATERIALIZED view if exists vr_day_sums_site cascade;
create MATERIALIZED view vr_day_sums_site
as
select  date_trunc('day',request_date) as day,/* дата */
	gethostnamefromurl(url) as site, -- сайт
	sum(duration) as duration,/* общее время соединений  за день*/
        sum(bytes) as bytes, /* сумма байтов*/
	count(client_host) as conn_count /*всего соединений за день для определенного сайта*/
    from squidevents group by day,site;

---xml version
drop view if exists vr_xml_day_sums_site;
create or replace view vr_xml_day_sums_site
as
select a.*,xmlforest(xmlforest(a.day,a.site,a.duration,
	a.bytes,a.conn_count) as row) as row
        from vr_day_sums_site a;

/*загрузки по дням,клиентам и ссылкам*/
drop MATERIALIZED view if exists vr_day_client_url_download cascade;
create MATERIALIZED view vr_day_client_url_download
as
select
    day,
    b.address, -- ip
    a.url,
    b.name, -- hostname
	b.description,-- client host description
	a.duration,
    a.bytes,
    a.conn_count
from
    (select date_trunc('day',request_date) as day,
        client_host,
        url,
        sum(duration) as duration,
        sum(bytes) as bytes,
        count(url) as conn_count-- всего соединений для определенного url
    from squidevents a,contenttype b
    where a.content_type=b.id
    and b.download=true
    group by day,client_host,url) as a,
    clienthost b
    where a.client_host=b.id
    with no data;

REFRESH MATERIALIZED VIEW vr_day_client_url_download;

-- xml version
drop view if exists vr_xml_day_client_url_download;
create or replace view vr_xml_day_client_url_download
as
select a.*,
xmlforest(xmlforest(a.day,a.address,a.name,a.description,
	    a.url,a.duration,a.bytes,a.conn_count) as row) as row
        from vr_day_client_url_download a;

/*
select substring(url from '[^\/]*$'),address,conn_count from vr_day_downloads
    where day='2015-12-20'::date order by 1
*/

/*загрузки по дням и клиентам */
drop MATERIALIZED view if exists vr_day_client_download cascade;
create MATERIALIZED view vr_day_client_download
as
select
    day,
    b.address, -- ip
    b.name, -- hostname
	b.description,-- client host description
	a.duration,
    a.bytes,
    a.conn_count
from
    (select date_trunc('day',request_date) as day,
        client_host,
        sum(duration) as duration,
        sum(bytes) as bytes,
        count(url) as conn_count-- всего соединений для определенного url
    from squidevents a,contenttype b
    where a.content_type=b.id
    and b.download=true
    group by day,client_host) as a,
    clienthost b
    where a.client_host=b.id
    with no data;

REFRESH MATERIALIZED VIEW vr_day_client_download;

-- xml version
drop view if exists vr_xml_day_client_download;
create or replace view vr_xml_day_client_download
as
select a.*,
xmlforest(xmlforest(a.day,a.address,a.name,a.description,
	    a.duration,a.bytes,a.conn_count) as row) as row
        from vr_day_client_download a;


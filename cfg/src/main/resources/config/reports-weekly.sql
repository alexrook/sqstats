/*итоги за неделю */
drop MATERIALIZED view if exists vr_week_sums cascade;
create MATERIALIZED view vr_week_sums
as
select date_trunc('week',request_date) as week,/* неделя */
	sum(duration) as duration,/* общее время соединений */
        sum(bytes) as bytes, /* общая сумма байтов */
	count(client_host) as conn_count /*всего соединений за один неделю*/
    from squidevents group by week;

---xml version 
drop view if exists vr_xml_week_sums;
create or replace view vr_xml_week_sums
as
select a.*,xmlforest(xmlforest(a.week,a.duration,a.bytes,a.conn_count) as row) as row from vr_week_sums a;

/*итоги за неделю по клиентам*/
drop MATERIALIZED view if exists vr_week_sums_client cascade;
create MATERIALIZED view vr_week_sums_client
as 
select  week,
	b.address, -- ip
	b.name, -- hostname
	b.description,-- client host description
	duration,bytes,conn_count
from
(select  date_trunc('week',request_date) as week,/* неделя */
	client_host,
	sum(duration) as duration,/* общее время соединения  за неделю для клиента */
        sum(bytes) as bytes, /* сумма байтов для клиента */
	count(client_host) as conn_count /*всего соединений за неделю для определенного клиента*/
    from squidevents
    group by week,client_host) as a,
    clienthost b
    where a.client_host=b.id;

---xml version
drop view if exists vr_xml_week_sums_client cascade;
create or replace view vr_xml_week_sums_client
as
select a.*,xmlforest(xmlforest(a.week,a.address,a.name,a.description,
	a.duration,a.bytes,a.conn_count) as row) as row
        from vr_week_sums_client a;


/*итоги за неделю по клиентам и сайтам*/
drop MATERIALIZED view if exists vr_week_sums_client_site cascade;
create MATERIALIZED view vr_week_sums_client_site
as
select  week,
	b.address, -- ip
	b.name, -- hostname
	b.description,-- client host description
	site,
	duration,bytes,conn_count
from
(select date_trunc('week',request_date) as week,/* дата */
	client_host,/* клиент */
	gethostnamefromurl(url) as site, -- сайт
	sum(duration) as duration,/* общее время соединения  за неделю для клиента по сайтам*/
        sum(bytes) as bytes, /* сумма байтов для клиента по сайтам*/
	count(client_host) as conn_count /*всего соединений за неделю для определенного клиента и сайта*/
    from squidevents group by week,client_host,site) as a,
    clienthost b
    where b.id=a.client_host;

---xml version
drop view if exists vr_xml_week_sums_client_site;
create or replace view vr_xml_week_sums_client_site
as
select a.*,
xmlforest(xmlforest(a.week,a.address,a.name,a.description,
	    a.site,a.duration,a.bytes,a.conn_count) as row) as row
        from vr_week_sums_client_site a;


/*итоги за неделю по сайтам*/
drop MATERIALIZED view if exists vr_week_sums_site cascade;
create MATERIALIZED view vr_week_sums_site
as
select  date_trunc('week',request_date) as week,/* дата */
	gethostnamefromurl(url) as site, -- сайт
	sum(duration) as duration,/* общее время соединений за неделю*/
        sum(bytes) as bytes, /* сумма байтов*/
	count(client_host) as conn_count /*количество соединений за неделю для определенного сайта*/
    from squidevents group by week,site;

---xml version
drop view if exists vr_xml_week_sums_site;
create or replace view vr_xml_week_sums_site
as
select a.*,xmlforest(xmlforest(a.week,a.site,a.duration,
	a.bytes,a.conn_count) as row) as row
        from vr_week_sums_site a;


---загрузки

/*загрузки по неделям и клиентам */
drop MATERIALIZED view if exists vr_week_client_download cascade;
create MATERIALIZED view vr_week_client_download
as
select
    week,
    b.address, -- ip
    b.name, -- hostname
	b.description,-- client host description
	a.duration,
    a.bytes,
    a.conn_count
from
    (select date_trunc('week',request_date) as week,
        client_host,
        sum(duration) as duration,
        sum(bytes) as bytes,
        count(url) as conn_count-- всего соединений для определенного url
    from squidevents a,contenttype b
    where a.content_type=b.id
    and b.download=true
    group by week,client_host) as a,
    clienthost b
    where a.client_host=b.id
    with no data;

REFRESH MATERIALIZED VIEW vr_week_client_download;

-- xml version
drop view if exists vr_xml_week_client_download;
create or replace view vr_xml_week_client_download
as
select a.*,
xmlforest(xmlforest(a.week,a.address,a.name,a.description,
	    a.duration,a.bytes,a.conn_count) as row) as row
        from vr_week_client_download a;

/*загрузки по дням,клиентам и ссылкам*/
drop MATERIALIZED view if exists vr_week_client_url_download cascade;
create MATERIALIZED view vr_week_client_url_download
as
select
    week,
    b.address, -- ip
    a.url,
    b.name, -- hostname
	b.description,-- client host description
	a.duration,
    a.bytes,
    a.conn_count
from
    (select date_trunc('week',request_date) as week,
        client_host,
        url,
        sum(duration) as duration,
        sum(bytes) as bytes,
        count(url) as conn_count-- всего соединений для определенного url
    from squidevents a,contenttype b
    where a.content_type=b.id
    and b.download=true
    group by week,client_host,url) as a,
    clienthost b
    where a.client_host=b.id
    with no data;

REFRESH MATERIALIZED VIEW vr_week_client_url_download;

-- xml version
drop view if exists vr_xml_week_client_url_download;
create or replace view vr_xml_week_client_url_download
as
select a.*,
xmlforest(xmlforest(a.week,a.address,a.name,a.description,
	    a.url,a.duration,a.bytes,a.conn_count) as row) as row
        from vr_week_client_url_download a;


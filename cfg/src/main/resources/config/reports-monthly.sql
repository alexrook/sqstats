/*итоги за месяц */
drop MATERIALIZED view if exists vr_month_sums cascade;
create MATERIALIZED view vr_month_sums
as
select date_trunc('month',request_date) as month,/* месяц */
	sum(duration) as duration,/* общее время соединений */
        sum(bytes) as bytes, /* общая сумма байтов */
	count(client_host) as conn_count /*всего соединений за один месяц*/
    from squidevents group by month;

---xml version 
drop view if exists vr_xml_month_sums;
create or replace view vr_xml_month_sums
as
select a.*,xmlforest(xmlforest(a.month,a.duration,a.bytes,a.conn_count) as row) as row from vr_month_sums a;

/*итоги за месяц по клиентам*/
drop MATERIALIZED view if exists vr_month_sums_client cascade;
create MATERIALIZED view vr_month_sums_client
as 
select  month,
	b.address, -- ip
	b.name, -- hostname
	b.description,-- client host description
	duration,bytes,conn_count
from
(select  date_trunc('month',request_date) as month,/* месяц */
	client_host,
	sum(duration) as duration,/* общее время соединения  за месяц для клиента */
        sum(bytes) as bytes, /* сумма байтов для клиента */
	count(client_host) as conn_count /*всего соединений за месяц для определенного клиента*/
    from squidevents
    group by month,client_host) as a,
    clienthost b
    where a.client_host=b.id;

---xml version
drop view if exists vr_xml_month_sums_client cascade;
create or replace view vr_xml_month_sums_client
as
select a.*,xmlforest(xmlforest(a.month,a.address,a.name,a.description,
	a.duration,a.bytes,a.conn_count) as row) as row
        from vr_month_sums_client a;


/*итоги за месяц по клиентам и сайтам*/
drop MATERIALIZED view if exists vr_month_sums_client_site cascade;
create MATERIALIZED view vr_month_sums_client_site
as
select  month,
	b.address, -- ip
	b.name, -- hostname
	b.description,-- client host description
	site,
	duration,bytes,conn_count
from
(select date_trunc('month',request_date) as month,/* дата */
	client_host,/* клиент */
	gethostnamefromurl(url) as site, -- сайт
	sum(duration) as duration,/* общее время соединения  за месяц для клиента по сайтам*/
        sum(bytes) as bytes, /* сумма байтов для клиента по сайтам*/
	count(client_host) as conn_count /*всего соединений за месяц для определенного клиента и сайта*/
    from squidevents group by month,client_host,site) as a,
    clienthost b
    where b.id=a.client_host;

---xml version
drop view if exists vr_xml_month_sums_client_site;
create or replace view vr_xml_month_sums_client_site
as
select a.*,
xmlforest(xmlforest(a.month,a.address,a.name,a.description,
	    a.site,a.duration,a.bytes,a.conn_count) as row) as row
        from vr_month_sums_client_site a;


/*итоги за месяц по сайтам*/
drop MATERIALIZED view if exists vr_month_sums_site cascade;
create MATERIALIZED view vr_month_sums_site
as
select  date_trunc('month',request_date) as month,/* дата */
	gethostnamefromurl(url) as site, -- сайт
	sum(duration) as duration,/* общее время соединений за месяц*/
        sum(bytes) as bytes, /* сумма байтов*/
	count(client_host) as conn_count /*количество соединений за месяц для определенного сайта*/
    from squidevents group by month,site;

---xml version
drop view if exists vr_xml_month_sums_site;
create or replace view vr_xml_month_sums_site
as
select a.*,xmlforest(xmlforest(a.month,a.site,a.duration,
	a.bytes,a.conn_count) as row) as row
        from vr_month_sums_site a;


---загрузки

/*загрузки по месяцам и клиентам */
drop MATERIALIZED view if exists vr_month_client_download cascade;
create MATERIALIZED view vr_month_client_download
as
select
    month,
    b.address, -- ip
    b.name, -- hostname
	b.description,-- client host description
	a.duration,
    a.bytes,
    a.conn_count
from
    (select date_trunc('month',request_date) as month,
        client_host,
        sum(duration) as duration,
        sum(bytes) as bytes,
        count(url) as conn_count-- всего соединений для определенного url
    from squidevents a,contenttype b
    where a.content_type=b.id
    and b.download=true
    group by month,client_host) as a,
    clienthost b
    where a.client_host=b.id
    with no data;

REFRESH MATERIALIZED VIEW vr_month_client_download;

-- xml version
drop view if exists vr_xml_month_client_download;
create or replace view vr_xml_month_client_download
as
select a.*,
xmlforest(xmlforest(a.month,a.address,a.name,a.description,
	    a.duration,a.bytes,a.conn_count) as row) as row
        from vr_month_client_download a;

/*загрузки по дням,клиентам и ссылкам*/
drop MATERIALIZED view if exists vr_month_client_url_download cascade;
create MATERIALIZED view vr_month_client_url_download
as
select
    month,
    b.address, -- ip
    a.url,
    b.name, -- hostname
	b.description,-- client host description
	a.duration,
    a.bytes,
    a.conn_count
from
    (select date_trunc('month',request_date) as month,
        client_host,
        url,
        sum(duration) as duration,
        sum(bytes) as bytes,
        count(url) as conn_count-- всего соединений для определенного url
    from squidevents a,contenttype b
    where a.content_type=b.id
    and b.download=true
    group by month,client_host,url) as a,
    clienthost b
    where a.client_host=b.id
    with no data;

REFRESH MATERIALIZED VIEW vr_month_client_url_download;

-- xml version
drop view if exists vr_xml_month_client_url_download;
create or replace view vr_xml_month_client_url_download
as
select a.*,
xmlforest(xmlforest(a.month,a.address,a.name,a.description,
	    a.url,a.duration,a.bytes,a.conn_count) as row) as row
        from vr_month_client_url_download a;


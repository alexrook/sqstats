--итоги за год 
drop MATERIALIZED view if exists vr_year_sums cascade;
create MATERIALIZED view vr_year_sums
as
select  date_trunc('year',request_date) as year,-- year timestamp
        EXTRACT(YEAR FROM date_trunc('year',request_date))  as dyear,-- year 
	sum(duration) as duration,-- общее время соединений 
        sum(bytes) as bytes, -- общая сумма байтов 
	count(client_host) as conn_count --всего соединений за один год
    from squidevents group by year;

---xml version 
drop view if exists vr_xml_year_sums;
create or replace view vr_xml_year_sums
as
select a.*,xmlforest(xmlforest(a.year,a.dyear,a.duration,a.bytes,a.conn_count) as row) as row from vr_year_sums a;

--итоги за год по клиентам
drop MATERIALIZED view if exists vr_year_sums_client cascade;
create MATERIALIZED view vr_year_sums_client
as 
select  year,
	b.address, -- ip
	b.name, -- hostname
	b.description,-- client host description
	duration,bytes,conn_count
from
(select  date_trunc('year',request_date) as year,-- год 
	client_host,
	sum(duration) as duration,-- общее время соединения  за год для клиента 
        sum(bytes) as bytes, -- сумма байтов для клиента 
	count(client_host) as conn_count --всего соединений за год для определенного клиента
    from squidevents
    group by year,client_host) as a,
    clienthost b
    where a.client_host=b.id;

---xml version
drop view if exists vr_xml_year_sums_client cascade;
create or replace view vr_xml_year_sums_client
as
select a.*,xmlforest(xmlforest(a.year,a.address,a.name,a.description,
	a.duration,a.bytes,a.conn_count) as row) as row
        from vr_year_sums_client a;

--загрузки по годам и клиентам 
drop MATERIALIZED view if exists vr_year_client_download cascade;
create MATERIALIZED view vr_year_client_download
as
select
    year,
    b.address, -- ip
    b.name, -- hostname
	b.description,-- client host description
	a.duration,
    a.bytes,
    a.conn_count
from
    (select date_trunc('year',request_date) as year,
        client_host,
        sum(duration) as duration,
        sum(bytes) as bytes,
        count(url) as conn_count-- всего соединений для определенного url
    from squidevents a,contenttype b
    where a.content_type=b.id
    and b.download=true
    group by year,client_host) as a,
    clienthost b
    where a.client_host=b.id
    with no data;

REFRESH MATERIALIZED VIEW vr_year_client_download;

-- xml version
drop view if exists vr_xml_year_client_download;
create or replace view vr_xml_year_client_download
as
select a.*,
xmlforest(xmlforest(a.year,a.address,a.name,a.description,
	    a.duration,a.bytes,a.conn_count) as row) as row
        from vr_year_client_download a;


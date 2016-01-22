/*
    'download' content types
    for use in reports
*/

-- application
update contenttype set download=true where value='application/octet-stream';
update contenttype set download=true where value='application/pdf';
update contenttype set download=true where value='application/zip';
update contenttype set download=true where value='application/gzip';
update contenttype set download=true where value='application/postscript';

-- audio
update contenttype set download=true where value='audio/mp4';
update contenttype set download=true where value='audio/mpeg';

--video
update contenttype set download=true where value='video/mpeg';
update contenttype set download=true where value='video/mp4';
update contenttype set download=true where value='video/quicktime';
update contenttype set download=true where value='video/3gpp';
update contenttype set download=true where value='video/3gpp2';

--vendor
update contenttype set download=true where value like 'application/vnd.openxmlformats%';
update contenttype set download=true where value like 'application/vnd.oasis%';
update contenttype set download=true where value like 'application/vnd.android%';
update contenttype set download=true where value like 'application/vnd.ms%';
update contenttype set download=true where value='application/msword';

--unknown+nonstandart
update contenttype set download=true where value='application/x-dvi';
update contenttype set download=true where value='application/x-latex';
update contenttype set download=true where value='application/x-rar-compressed';
update contenttype set download=true where value='application/x-tar';
--update contenttype set download=true where value='-'; --unknown type from squid access.log

-- sqstats collected
/*select 'update contenttype set download=true where value='''||value||''';'
from contenttype where parentId=12 and download=false order by 1;*/
 --update contenttype set download=true where value='1';
 update contenttype set download=true where value='application/docx';
 update contenttype set download=true where value='application/download';
 update contenttype set download=true where value='application/force-download';
 update contenttype set download=true where value='application/fzip';
 update contenttype set download=true where value='application/microsoftpatch';
 update contenttype set download=true where value='application/octet_stream';
 update contenttype set download=true where value='application/pkcs7-crl';
 update contenttype set download=true where value='application/pkix-cert';
 update contenttype set download=true where value='application/pkix-crl';
 update contenttype set download=true where value='application/rar';
 update contenttype set download=true where value='application/rtf';
 update contenttype set download=true where value='application/x-123';
 update contenttype set download=true where value='application/x509-ca-cert';
 update contenttype set download=true where value='application/x-7z-compressed';
 update contenttype set download=true where value='application/x-amf';
 update contenttype set download=true where value='application/x-bzip';
 update contenttype set download=true where value='application/x-chrome-extension';
 update contenttype set download=true where value='application/x-dosexec';
 update contenttype set download=true where value='application/x-dwg';
 update contenttype set download=true where value='application/x-fcs';
 update contenttype set download=true where value='application/x-httpd-zip';
 update contenttype set download=true where value='application/x-mpegurl';
 update contenttype set download=true where value='application/x-mrd';
 update contenttype set download=true where value='application/x-msdos-program';
 update contenttype set download=true where value='application/x-msdownload';
 update contenttype set download=true where value='application/x-msi';
 update contenttype set download=true where value='application/x-pkcs7-crl';
 update contenttype set download=true where value='application/x-rar';
 update contenttype set download=true where value='application/x-sdlc';
 update contenttype set download=true where value='application/x-steam-chunk';
 update contenttype set download=true where value='application/x-steam-manifest';
 update contenttype set download=true where value='application/x-unknown';
 update contenttype set download=true where value='application/x-x509-ca-cert';
 update contenttype set download=true where value='application/x-zip-compressed';
 update contenttype set download=true where value='audio/x-m4a';
 update contenttype set download=true where value='audio/x-wav';
 update contenttype set download=true where value='binary/octet-stream';
 update contenttype set download=true where value='force-download';
 update contenttype set download=true where value='none';
 update contenttype set download=true where value='octet/stream';
 update contenttype set download=true where value='unknown';
 update contenttype set download=true where value='unknown/unknown';
 update contenttype set download=true where value='video/f4f';
 update contenttype set download=true where value='video/mp2t';
 update contenttype set download=true where value='video/x-f4f';
 update contenttype set download=true where value='video/x-matroska';
 update contenttype set download=true where value='video/x-mp4';
 update contenttype set download=true where value='video/x-msvideo';
 update contenttype set download=true where value='image/exe';

/*
    sqstats collected --maintenance view
    потенциальные кандидаты на download=true
    (выбрать автоматически собранные content types
    для которых не указан флаг download
    и которые НЕ подходят под указанный в 'similar' to шаблон)
*/
create or replace view vm_collected_contenttypes
as
select 'update contenttype set download=true where value='''||value||''';'
from contenttype where parentId=12/*unknown+nonstandart - automatic harvested types*/
and download=false /*не обработанные*/ 
and value not similar to '%(json|javascript|jquery|text|image|img|imag|flash|png|jpeg|jpg|font|xml)%'
order by 1;

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


--download Content-Types
drop view if exist vr_xml_download_content_types;
create or replace view vr_xml_download_content_types
as
select a.*,
        xmlforest(xmlforest(a.value,a.description) as row) as row
        from contenttype a 
        where a.download=true
        and not parentId is null
        order by a.value;
        
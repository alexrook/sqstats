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

insert into sitegroup (id,regex,name) values(1,'.*windows.*\.(com|net)','windows');
insert into sitegroup (id,regex,name) values(2,'.*creativecdn\.com','creativecdn.com');
insert into sitegroup (id,regex,name) values(3,'.*cmle\.ru','cmle.ru');
insert into sitegroup (id,regex,name) values(4,'.*mixmarket\.biz','mixmarket.biz');
insert into sitegroup (id,regex,name) values(5,'.*yandex\.(net|ru)','yandex.ru');
insert into sitegroup (id,regex,name) values(6,'.*tumblr\.com','tumblr.com');
insert into sitegroup (id,regex,name) values(7,'.*doubleclick\.net','doubleclick.net');
insert into sitegroup (id,regex,name) values(8,'.*cdnvideo\.ru','cdnvideo.ru');
insert into sitegroup (id,regex,name) values(9,'.*(google|gstatic).*\.(com|ru|ua)','google.com');
insert into sitegroup (id,regex,name) values(10,'.*gismeteo\.ru','gismeteo.ru');
insert into sitegroup (id,regex,name) values(11,'.*cloudfront\.net','cloudfront.net');
insert into sitegroup (id,regex,name) values(12,'.*microsoft\.com','microsoft.com');
insert into sitegroup (id,regex,name) values(13,'.*marketgid\.com','marketgid.com');
insert into sitegroup (id,regex,name) values(14,'.*mail\.ru','mail.ru');
insert into sitegroup (id,regex,name) values(15,'.*utorrent.com','utorrent.com');
insert into sitegroup (id,regex,name) values(16,'.*eset\.com','eset.com');
insert into sitegroup (id,regex,name) values(17,'.*olx\.com','olx.com');
insert into sitegroup (id,regex,name) values(18,'.*betweendigital\.com','betweendigital.com');

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





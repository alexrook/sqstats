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

/*
    вносите данные в таблицу с substr=false
    если хотите группировать по определенному имени
    i.e regex='.*(yandex|yadro)\.(com|ru)' -> name='yandex.ru'
    
    вносите данные в таблицу с substr=true
    если хотите группировать c помощью функции substring
    определенную строку из имени сайта
    к примеру regex='[^.]*\.[^.]*$' вернет домен 2 уровня (aaa.bbb.com->bbb.com)
    
    вносите данные в таблицу с substr=true
    если хотите группировать раздельно определенные домены 3 уровня
    определенную строку из имени сайта
    к примеру regex='.*livejournal\.com' вернет полные имена жж-страниц
    
    see also sitedroup-data.sql for defaults
        getGroupHostNameFromSite(varchar) for rules
    
*/
drop table if exists sitegroup cascade;
create table sitegroup 
(id int primary key,
 regex varchar(33) unique,
 name varchar(150) unique,
 substr boolean default false,
 description varchar(350)
);

drop view if exists vr_xml_sitegroup cascade;
create or replace view vr_xml_sitegroup as
select  a.*,
        xmlforest(xmlforest(a.id,a.regex,a.substr,a.name,a.description) as row) as row
        from sitegroup a order by a.id asc;
        
        
drop function if exists getGroupHostNameFromSite(varchar) cascade;
create or replace function getGroupHostNameFromSite(site varchar) 
returns varchar 
as
$$
declare 
    result varchar;
begin
    /**
        сначала выбрать сайты, которые хотим группировать по определенному имени
        к примеру
        все сайты windows, windowsupdate, microsoft
            группировать как microsoft.com
    */
    select name from sitegroup into result
        where substr=false and
        site ~ regex
    fetch first row only;

    if char_length(result)>0  then
        return trim(result);
    else
    /*
        в случае отсутствия группировки по имени
        группировать через substring
    */
        select substring(site from regex) from sitegroup into result
        where substr=true and
        substring(site from regex) is not null
        order by id asc --first match wins
        fetch first row only;  
    end if;

    if char_length(result)>0  then
        return trim(result);
    end if;
    /* если никакая группировка не сработала вернуть имя сайта как есть*/    
    return site;    
end;
$$ 
language plpgsql;


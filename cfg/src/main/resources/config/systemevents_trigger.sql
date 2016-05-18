/*
create table squidevents (id bigint not null primary key,
		    from_squid varchar(60),
		    request_date timestamp,
		    duration bigint,
		    client_host varchar(255),
		    url varchar,
		    http_result varchar,
    		    bytes bigint,
		    method varchar(115), -- GET, PUT, OPTIONS ...
		    hier_code varchar(115),
		    content_type varchar(115));

create table reportsbase
(
    id int unique,
    day timestamp,
    week timestamp, 
    month timestamp,
    year double,
    site varchar(150),
    sitegroup varchar(150)
);

*/

drop function if exists f_tai_systemevents() cascade;
create or replace function f_tai_systemevents()
    returns trigger
AS
$$
DECLARE
parsed_message varchar[];
req_date timestamp;
site varchar;
sitegroup varchar;
BEGIN
	
    -- http://wiki.squid-cache.org/Features/LogFormat#Default_Formats
    parsed_message=regexp_split_to_array(trim(NEW.message),E'\\s+');
    req_date=to_timestamp(((regexp_split_to_array(trim(parsed_message[1]),E'\\.'))[1])::double precision); --timestamp without millsec

     parsed_message[3]=popClientHost(parsed_message[3]);
     parsed_message[4]=popHttpResult(parsed_message[4]);
     parsed_message[6]=popMethod(parsed_message[6]);
     parsed_message[10]=popContentType(parsed_message[10]);

    insert into squidevents(id,
			    from_squid,
			    request_date,
			    duration,
			    client_host,
			    url,
			    http_result,
			    bytes,
			    method,
			    hier_code,
			    content_type) values(NEW.id,
					 NEW.fromhost,
					 req_date,
					 parsed_message[2]::bigint, --duration
					 parsed_message[3]::int, --host
					 parsed_message[7], --url
					 parsed_message[4]::int, --http_result
					 parsed_message[5]::bigint, --bytes
					 parsed_message[6]::int, --method
					 parsed_message[9], --hier_code
					 parsed_message[10]::int --content-type
						    );

    site=getHostNameFromUrl(parsed_message[7]);
    sitegroup=getGroupHostNameFromSite(site);

    insert into reportsbase(id,
			     day,	
			     week, 
			     month,	
			     year,
			     site,
			     sitegroup) values (NEW.id,
			    date_trunc('day',req_date),
			    date_trunc('week',req_date), 
			    date_trunc('month',req_date),
			    date_part('year',req_date),
			    site,
			    sitegroup);

return NEW;

EXCEPTION
		WHEN OTHERS then
			RAISE NOTICE 'some weird data';
			addWeirdData(NEW); 
	   return NEW;
END;
$$
language plpgsql;


drop trigger if exists tai_SystemEvents on SystemEvents;

create trigger tai_SystemEvents after insert
on SystemEvents
for each row
execute procedure f_tai_systemevents();


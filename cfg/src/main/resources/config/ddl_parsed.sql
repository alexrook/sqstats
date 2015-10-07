drop table if exists squid_events ;

create table squid_events (id bigint not null primary key,
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

create or replace function ft_ins()
    returns trigger
AS
$$
declare
parsed_message varchar[];
req_date timestamp;
begin
    parsed_message=regexp_split_to_array(trim(NEW.message),E'\\s+');
    req_date=to_timestamp(((regexp_split_to_array(trim(parsed_message[1]),E'\\.'))[1])::double precision); --timestamp without millsec
    insert into squid_events(id,
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
					 parsed_message[3], --host
					 parsed_message[7], --url
					 parsed_message[4], --http_result
					 parsed_message[5]::bigint, --bytes
					 parsed_message[6], --method
					 parsed_message[9], --hier_code
					 parsed_message[10] --content-type
						    );
    return NEW;
end;
$$
language plpgsql;


drop trigger if exists ti_SystemEvents on SystemEvents;
create trigger ti_SystemEvents after insert
on SystemEvents
for each row
execute procedure ft_ins();


drop table if exists squid_events ;

create table squid_events (id bigint not null primary key,
		    request_date timestamp,
		    duration bigint,
		    client_host varchar(255),
		    url varchar,
		    http_result varchar,
    		    bytes bigint,
		    method varchar(5),
		    hier_code varchar(115),
		    content_type varchar(115));

create or replace function ft_ins(id bigint,data varchar)
    returns void
AS
$$
declare
parsed_message varchar[];
req_date timestamp;
begin
    parsed_message=regexp_split_to_array(trim(data),E'\\s+');
    req_date=to_timestamp(((regexp_split_to_array(trim(parsed_message[1]),E'\\.'))[1])::double precision); --timestamp without millsec
    insert into squid_events(id,
			    request_date,
			    duration,
			    client_host,
			    url,
			    http_result,
			    bytes,
			    method,
			    hier_code,
			    content_type) values(id,
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
end;
$$
language plpgsql;

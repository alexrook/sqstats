drop table if exists squid_events cascade;

create table squid_events (
		    id bigint not null primary key,
		    from_squid varchar(60),
		    request_date timestamp,
		    duration bigint,
		    client_host int,
		    url varchar,
		    http_result int,
    		    bytes bigint,
		    method int, -- GET, PUT, OPTIONS ...
		    hier_code varchar(115),
		    content_type int
		    );


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
		        year double precision,
		        site varchar(150),
		        sitegroup varchar(150)
		    );
    
*/
    insert into reportsbase(id,
			     day,	
			     week, 
			     month,	
			     year,
			     site,
			     sitegroup) select
					    id,
					    date_trunc('day',request_date),
					    date_trunc('week',request_date),
					    date_trunc('month',request_date),
					    date_part('year',request_date),
					    getHostNameFromUrl(url),
					    getGroupHostFromSite(getHostNameFromUrl(url))
					    from squidevents
					    where id<(select min(id) from reportsbase);



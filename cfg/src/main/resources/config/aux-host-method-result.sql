/*
*	auxiliary tables-clienthost
*/

/* client host */
drop table if exists clienthost cascade;
create table clienthost (
    id serial not null primary key,
    address inet unique,
    name varchar(255),
    description varchar(255)
);


drop function if exists  getClientHostId(varchar);
create or replace function getClientHostId(cHost varchar)
returns int
immutable
as
$$
declare 
    result int;
begin
    select id into result from clienthost where cHost::inet=address;
    return result;
end;
$$ language plpgsql;

--populate clienthost table
drop function if exists  popClientHost(varchar);
create or replace function popClientHost(cHost varchar)
returns int
as
$$
declare 
    result int;
begin
    select id into result from clienthost where cHost::inet=address;
    if result is null 
	then
	    select  nextval('clienthost_id_seq') into result;
	    insert into clienthost(id,address,description) 
			values(result,cHost::inet,'auto-insert');
    end if;
    return result;
end;
$$ language plpgsql;


/* http results*/
drop table if exists httpresult cascade;
create table httpresult (
    id serial not null primary key,
    name varchar(115),
    code smallint,
    description varchar(255)
);


drop function if exists  getHttpResultId(varchar);
create or replace function getHttpResultId(http_result varchar)
returns int
immutable
as
$$
declare 
    result int;
    lname varchar=null;
begin
    lname=upper(trim(split_part(http_result,'/',1)));
    select id into result  from httpresult a where lname=upper(trim(a.name));
    return result;
end;
$$ language plpgsql;

-- populate http result
drop function if exists  popHttpResult(varchar);
create or replace function popHttpResult(http_result varchar)
returns int
as
$$
declare 
    result int;
    lname varchar=null;
begin
    lname=upper(trim(split_part(http_result,'/',1)));
    if not lname is null 
	then 
		select id into result  from httpresult a where lname=upper(trim(a.name));
		if result is null 
			then
			    select  nextval('httpresult_id_seq') into result;
			    insert into httpresult(id,name,code,description) 
			    	values(result,lname,split_part(http_result,'/',2)::smallint,'auto-insert');
	        end if;
	else --weird http results
		select  nextval('httpresult_id_seq') into result;
		insert into httpresult(id,name,code,description) 
		    	values(result,lname,0,'auto-insert');
    end if;

    return result;

end;
$$ language plpgsql;

/* method */
drop table if exists method cascade;
create table method (
    id serial not null primary key,
    name varchar(115),
    description varchar(255)
);


drop function if exists  getMethodId(varchar);
create or replace function getMethodId(method varchar)
returns int
immutable
as
$$
declare 
    result int;
    lname varchar=null;
begin
    lname=upper(trim(method));
    select id into result  from method a where lname=upper(trim(a.name));
    return result;
end;
$$ language plpgsql;

-- populate http result
drop function if exists  popMethod(varchar);
create or replace function popMethod(method varchar)
returns int
as
$$
declare 
    result int;
    lname varchar=null;
begin
    lname=upper(trim(method));
    select id into result  from method a where lname=upper(trim(a.name));
	if result is null 
		then
        	    select  nextval('method_id_seq') into result;
		    insert into method(id,name,description) 
		    	values(result,lname,'auto-insert');
        end if;
    return result;

end;
$$ language plpgsql;


/*
*	auxiliary tables-clienthost
*/

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


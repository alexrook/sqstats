/*
 *  report  base views
 */

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

drop materialized view if exists vr_reportsbase cascade;
create materialized view vr_reportsbase
as
select a.*,b.day,b.week,b.month,b.year,b.site,b.sitegroup
from
squidevents a, reportsbase b
where a.id=b.id;




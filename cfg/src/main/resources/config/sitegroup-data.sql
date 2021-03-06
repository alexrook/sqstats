delete from sitegroup;

insert into sitegroup (id,regex,name) values(1,'.*windows.*\.(com|net)','windows.com');
insert into sitegroup (id,regex,name) values(2,'.*(yandex|yadro)\.(net|ru)','yandex.ru');
insert into sitegroup (id,regex,name) values(3,'.*(google|gstatic).*\.(com|ru|ua)','google.com');


-- substr values
insert into sitegroup (id,regex,substr,description)
                values(99993,'[^.]*\.[[cno][oer][mtg]]?\.ru$',true,
                'считать отдельно итоги для  доменов (com,org,net) *.ru');
insert into sitegroup (id,regex,substr,description)
                values(99994,'[^.]*\.[^.]*\.ua$',true,
                'считать отдельно итоги для  доменов 3 уровня *.ua');
insert into sitegroup (id,regex,substr,description)
                values(99995,'\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}',true,
                'считать отдельно ipv4-addresses');
insert into sitegroup (id,regex,substr,description)
                values(99996,'.*xn----itbjhccqit6f\.xn--p1ai',true,
                'считать отдельно итоги для сайтов домена щелкино-рк.рф');
insert into sitegroup (id,regex,substr,description)
                values(99997,'.*narod\.ru',true,
                'считать отдельно итоги для сайтов narod.ru');
insert into sitegroup (id,regex,substr,description)
                values(99998,'.*livejournal\.com',true,
                'считать отдельные итоги для ЖЖ-страниц');
insert into sitegroup (id,regex,substr,description)
                values(99999,'[^.]*\.[^.]+$',true,
                'return 2-level domain for default, i.e some.aaa.com ->aaa.com');

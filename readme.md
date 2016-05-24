# sqstats

Кофигурационные файлы squid, rsyslog, postgresql
и приложение j2ee для просмотра статистики.
В одном проекте, для удобства.

Цель - хранение статистики squid3 в базе данных.

Для сборки 

1. Внести в конфигурацию Squid3 правки в соответсвии с cfg/src/manin/resources/config/squid.conf
2. Настроить RSyslog на сброс статистики Squid в базу данных PostgreSQL (see cfg/src/manin/resources/config/rsyslog.d_10-squid.conf)
3. Создать базу данных PostgreSQL (see see cfg/src/manin/resources/config/run.sql)
4. Настроить Cron для периодического обновления материальных представлений-отчетов в PostgreSQL (see cfg/src/manin/resources/config/cron.*)
5. Cоздать файл local.properties по образцу local.properties.example
6. Выполнить `mvn clean package`
7. Развернуть приложение sqtstats.war на J2EE сервере

![SQStats screen](https://cloud.githubusercontent.com/assets/2620272/15465652/5a71d2d4-20de-11e6-8cb1-5c02f687d37a.png)



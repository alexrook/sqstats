#!/bin/sh


for i in 1 2 3 4 5 6 7 8 9
do
    echo "run psql reportsbase-insert-old..."
    psql -U ${db.username} -h ${db.host} ${db.name} -f reportsbase-insert-old.sql
    echo "waiting 3 min..."
    sleep 3m
done




#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    exit
fi

DATABASE=$1

COLLATE=utf8mb4_unicode_ci
ROW_FORMAT=DYNAMIC

TABLES=$(echo SHOW TABLES | mysql -uroot -s $DATABASE)

echo "ALTER DATABASE $DATABASE CHARACTER SET utf8mb4 COLLATE $COLLATE" | mysql -uroot $DATABASE

for TABLE in $TABLES ; do
  echo "ALTER TABLE $TABLE ROW_FORMAT=$ROW_FORMAT CHARACTER SET utf8mb4 COLLATE $COLLATE;" | mysql -uroot $DATABASE
done

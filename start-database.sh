#!/bin/bash

# This script starts the database server.
dbfile="/db-backup/bakup.sql"

echo "Adding data into MySQL"
/usr/sbin/mysqld &
sleep 5

mysqldump -h $host -u $user -p$password --single-transaction --databases $db > $dbfile

mysql --default-character-set=utf8 < $dbfile

rm $dbfile

mysqladmin shutdown
echo "finished"

# Now the provided user credentials are added
/usr/sbin/mysqld &
sleep 5
echo "Creating user"
echo "CREATE USER '$user' IDENTIFIED BY '$password'" | mysql --default-character-set=utf8
echo "GRANT ALL PRIVILEGES ON  $db. * TO '$user'@'%' WITH MAX_USER_CONNECTIONS $max_connections; FLUSH PRIVILEGES" | mysql --default-character-set=utf8
echo "finished"

# And we restart the server to go operational
mysqladmin shutdown
echo "Starting MySQL Server"
/usr/sbin/mysqld

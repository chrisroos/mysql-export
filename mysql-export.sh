#!/bin/bash

if [ $# != 1 ]; then
  echo "Usage: $0 database_name"
  exit 1
fi

database=$1

# TODO: How do I replace this with a bash alternative?
timestamp=`ruby -e "puts Time.now.strftime('%Y%m%d%H%M%S')"`
backup_directory=mysql_export.$1.$timestamp

mkdir -p $backup_directory
echo "Writing backups to $backup_directory"

for table in `mysql $database -uroot -e"SHOW TABLES" | grep -v 'Tables_in'`
do
  mysql $database -uroot -e"SELECT * FROM $table" > $backup_directory/$table.tsv
done
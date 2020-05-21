#!/bin/bash

set -e

timestamp=$(date +%s%N)
backupFolder=sql_backup/${timestamp}
mkdir -p "${backupFolder}"

function backupTable {
     rm sql/"${1}".sql
     mysqldump -e --hex-blob -hdb -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" "${MYSQL_DATABASE}" "${1}" > "${backupFolder}"/"${1}".sql
}

backupTable auction_house
backupTable chars
backupTable accounts
backupTable accounts_banned
backupTable char_effects
backupTable char_equip
backupTable char_exp
backupTable char_inventory
backupTable char_jobs
backupTable char_look
backupTable char_merit
backupTable char_pet
backupTable char_points
backupTable char_profile
backupTable char_skills
backupTable char_spells
backupTable char_stats
backupTable char_storage
backupTable char_vars
backupTable conquest_system
backupTable delivery_box
backupTable linkshells

if [[ -e sql/char_merits.sql ]]; then
  rm sql/char_merits.sql
fi

tar -jcvf "${backupFolder}".tar.bz2 "${backupFolder}"

if [ -f "${backupFolder}".tar.bz2 ]; then
     rm -rf "${backupFolder}"
fi

cd sql
for f in *.sql
  do
     echo -n "Importing $f into the database..."
     mysql -hdb -u "${MYSQL_USER}" -p"${MYSQL_PASSWORD}" "${MYSQL_DATABASE}" < "$f" && echo "Success"
  done

mysql -hdb -u "${MYSQL_USER}" -p"${MYSQL_PASSWORD}" "${MYSQL_DATABASE}" < accounts_sessions.sql && echo "Success"
mysql -hdb -u "${MYSQL_USER}" -p"${MYSQL_PASSWORD}" "${MYSQL_DATABASE}" < accounts_parties.sql && echo "Success"
mysql -hdb -u "${MYSQL_USER}" -p"${MYSQL_PASSWORD}" "${MYSQL_DATABASE}" < triggers.sql && echo "Success"

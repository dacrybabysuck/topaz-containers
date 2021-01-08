#!/bin/bash

set -e

timestamp=$(date +%s%N)
backupFolder=sql_backup/${timestamp}
mkdir -p "${backupFolder}"

declare -a BackupTables=("auction_house" "chars" "accounts" "accounts_banned" "char_effects" "char_equip" "char_exp" "char_inventory" "char_jobs" "char_look" "char_merit" "char_pet" "char_points" "char_profile" "char_recast" "char_skills" "char_spells" "char_stats" "char_storage" "char_style" "char_unlocks" "char_vars" "conquest_system" "server_variables" "delivery_box" "linkshells")


function backupTable {
     mysqldump -e --hex-blob -hdb --no-create-info -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" "${MYSQL_DATABASE}" "${1}" > "${backupFolder}"/"${1}".sql
}

for val in ${BackupTables[@]}; do
   backupTable $val
done


if [[ -e sql/char_merits.sql ]]; then
  rm sql/char_merits.sql
fi

tar -jcvf "${backupFolder}".tar.bz2 "${backupFolder}"

if [ -f "${backupFolder}".tar.bz2 ]; then
     rm -rf "${backupFolder}"
fi

cd /topaz/sql
for f in *.sql
  do
     echo -n "Importing $f into the database..."
     mysql -hdb -u "${MYSQL_USER}" -p"${MYSQL_PASSWORD}" "${MYSQL_DATABASE}" < "$f" && echo "Success"
  done

mysql -hdb -u "${MYSQL_USER}" -p"${MYSQL_PASSWORD}" "${MYSQL_DATABASE}" < accounts_sessions.sql && echo "Success"
mysql -hdb -u "${MYSQL_USER}" -p"${MYSQL_PASSWORD}" "${MYSQL_DATABASE}" < accounts_parties.sql && echo "Success"
mysql -hdb -u "${MYSQL_USER}" -p"${MYSQL_PASSWORD}" "${MYSQL_DATABASE}" < triggers.sql && echo "Success"

if [[ -d /topaz/sql/custom && -f /topaz/scripts/globals/settings.lua ]]; then
  cd /topaz/sql/custom
  for f in *.sql
    do
     if grep -i -q "$(echo "$f" | cut -f 1 -d '.') = 1" /topaz/scripts/globals/settings.lua; then
       mysql -hdb -u "${MYSQL_USER}" -p"${MYSQL_PASSWORD}" "${MYSQL_DATABASE}" < $f && echo "Success"
     fi
    done
fi

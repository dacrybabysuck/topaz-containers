#!/bin/bash

set -e

timestamp=$(date +%s%N)
backupFolder=sql_backup/${timestamp}
mkdir -p "${backupFolder}"

declare -a BackupTables=("auction_house" "accounts" "chars" "accounts_banned" "char_effects" "char_equip" "char_exp" "char_inventory" "char_jobs" "char_look" "char_merit" "char_pet" "char_points" "char_profile" "char_recast" "char_skills" "char_spells" "char_stats" "char_storage" "char_style" "char_unlocks" "char_vars" "conquest_system" "server_variables" "delivery_box" "linkshells")

function backupTable {
     echo -n "Backing up table ${1}..."
     mysqldump -e --hex-blob -hdb --skip-triggers --no-create-info -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" "${MYSQL_DATABASE}" "${1}" > "${backupFolder}"/"${1}".sql && echo "Success"
}

function restoreTable {
     echo -n "Restoring table ${1}..."
     mysql -hdb -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" "${MYSQL_DATABASE}" -e "truncate table ${1}"
     mysql -hdb -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" "${MYSQL_DATABASE}" < "${backupFolder}"/"${1}".sql && echo "Success"
}

echo -n "Backing full database..."
mysqldump -e --hex-blob -hdb --skip-triggers --no-create-info -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" "${MYSQL_DATABASE}" > "${backupFolder}"/fulldb.sql && echo "Success"

for val in ${BackupTables[@]}; do
   backupTable $val
done


pushd /topaz/sql
for f in *.sql
  do
     echo -n "Importing $f into the database..."
     mysql -hdb -u "${MYSQL_USER}" -p"${MYSQL_PASSWORD}" "${MYSQL_DATABASE}" < "$f" && echo "Success"
  done
popd

for val in ${BackupTables[@]}; do
   restoreTable $val
done

tar -jcvf "${backupFolder}".tar.bz2 "${backupFolder}"

#if [ -f "${backupFolder}".tar.bz2 ]; then
#     rm -rf "${backupFolder}"
#fi

pushd /topaz/sql
mysql -hdb -u "${MYSQL_USER}" -p"${MYSQL_PASSWORD}" "${MYSQL_DATABASE}" < accounts_sessions.sql && echo "Success"
mysql -hdb -u "${MYSQL_USER}" -p"${MYSQL_PASSWORD}" "${MYSQL_DATABASE}" < accounts_parties.sql && echo "Success"
mysql -hdb -u "${MYSQL_USER}" -p"${MYSQL_PASSWORD}" "${MYSQL_DATABASE}" < triggers.sql && echo "Success"
popd

if [[ -d /topaz/sql/custom && -f /topaz/scripts/globals/settings.lua ]]; then
  cd /topaz/sql/custom
  for f in *.sql
    do
     if grep -i -q "$(echo "$f" | cut -f 1 -d '.') = 1" /topaz/scripts/globals/settings.lua; then
       mysql -hdb -u "${MYSQL_USER}" -p"${MYSQL_PASSWORD}" "${MYSQL_DATABASE}" < $f && echo "Success"
     fi
    done
fi


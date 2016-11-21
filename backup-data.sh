TIMESTAMP=$(date +%Y-%m-%d-%H-%M)
MYSQL_BACKUP="backup-sql-${TIMESTAMP}"
MONGO_BACKUP="backup-mongo-${TIMESTAMP}"




cd $BACKUP_DIR

echo "Backing up current sql from ${MYSQL_SERVER} to ${MYSQL_BACKUP}.sql"
mysqldump --host=${MYSQL_SERVER} --user=${MYSQL_USER} --password=${MYSQL_PASSWORD} ${MYSQL_DB} > ${MYSQL_BACKUP}.sql

echo "Updating backup-sql-latest.sql"
cp -rf ${MYSQL_BACKUP}.sql backup-sql-latest.sql


echo "Backing up server mongo to ${MONGO_BACKUP}"
mongodump --host ${MONGO_SERVER} --db ${MONGO_DB} --out ${MONGO_BACKUP}

echo "Zipping mongo data to ${MONGO_BACKUP}.tgz"
tar zcvf ${MONGO_BACKUP}.tgz -C ${MONGO_BACKUP} .

echo "Updating backup-mongo-latest.tgz"
cp -rf ${MONGO_BACKUP}.tgz backup-mongo-latest.tgz

echo "Removing mongo temp dir"
rm -rf ${MONGO_BACKUP}

echo "Removing files older than ${MAX_AGE_DAYS} days"
find ${BACKUP_DIR}/* -mtime +${MAX_AGE_DAYS} -type f -delete
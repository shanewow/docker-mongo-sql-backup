SQLRESTORE=restore-sql-latest
MONGRESTORE=restore-mongo-latest

cd $RESTORE_DIR

echo "Committing file: ${SQLRESTORE}.sql to db: ${MYSQL_DB}"
mysql --host=${MYSQL_SERVER} --user=${MYSQL_USER} --password=${MYSQL_PASSWORD} ${MYSQL_DB} < ${SQLRESTORE}.sql

echo "Creating directory ${MONGRESTORE}"
mkdir ${MONGRESTORE}

echo "Upackaging mongo data from server to ${MONGOBACKUP}"
tar -zxvf ${MONGRESTORE}.tgz -C ${MONGRESTORE}

echo "Dropping existing mongodb ${MONGO_DB}"
mongo ${MONGO_SERVER}/${MONGO_DB} --eval "db.dropDatabase()"

echo "Committing downloaded Mongo data"
mongorestore --host ${MONGO_SERVER} --db ${MONGO_DB} ${MONGRESTORE}/${MONGO_DB}



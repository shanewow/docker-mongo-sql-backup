FROM	ubuntu:14.04

#install mysql
RUN		apt-get update
RUN		apt-get install -y mysql-client

RUN apt-get install -y mongodb-clients

RUN apt-get install -y curl

#install cron
ENV		GO_CRON_VERSION v0.0.7


RUN		curl -L https://github.com/odise/go-cron/releases/download/${GO_CRON_VERSION}/go-cron-linux.gz \
		| zcat > /usr/local/bin/go-cron \
		&& chmod u+x /usr/local/bin/go-cron

# install backup scripts
COPY backup-data.sh /usr/local/bin/backup-data.sh
COPY backup-run.sh /usr/local/bin/backup-run.sh
COPY restore-data.sh /usr/local/bin/restore-data.sh
COPY restore-run.sh /usr/local/bin/restore-run.sh

RUN chmod u+x /usr/local/bin/backup-run.sh
RUN chmod u+x /usr/local/bin/backup-data.sh
RUN chmod u+x /usr/local/bin/restore-run.sh
RUN chmod u+x /usr/local/bin/restore-data.sh

RUN mkdir /backup
RUN mkdir /restore

VOLUME /restore
VOLUME /backup


ENV MYSQL_SERVER mysql-proxy-1
ENV MYSQL_USER root
ENV MYSQL_PASSWORD root
ENV MYSQL_DB main

ENV MAX_AGE_DAYS 10

ENV MONGO_SERVER mongo-router-1
ENV MONGO_USER root
ENV MONGO_PASSWORD root
ENV MONGO_DB files

ENV BACKUP_DIR /backup
ENV RESTORE_DIR /restore
		

#18080 http status port
EXPOSE		18080

ADD		docker-entrypoint.sh /usr/local/sbin/docker-entrypoint.sh
ENTRYPOINT	["/usr/local/sbin/docker-entrypoint.sh"]

CMD		["go-cron"]
		

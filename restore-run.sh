#!/bin/sh

PIDFILE=/var/run/restore-run.pid

if [ -f $PIDFILE ]; then
	echo $0 is already running with pid $(cat $PIDFILE), aborting!
	exit 1
fi

echo $$ >$PIDFILE

/usr/local/bin/restore-data.sh

retval=$?

rm $PIDFILE

exit $retval

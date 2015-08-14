LOGSTASHVER="logstash-1.5.3"
REPONAME="logstash-atlantis-manager"
REPOPATH="/root/atlantis-analytics"
LOGSTASHPATH="${REPOPATH}/${REPONAME}"
LOGSTASHDIR="${LOGSTASHPATH}/${LOGSTASHVER}"
CONFIGDIR="${LOGSTASHPATH}/config-files"
LOGPATH="/var/log/atlantis/logstash"

export SINCEDB_DIR="$REPOPATH"

if [ -e "${LOGPATH}/out.log" ]; then
	rm "${LOGPATH}/out.log"
fi
if [ -e "${LOGPATH}/err.log" ]; then
	rm "${LOGPATH}/err.log"
fi

$LOGSTASHDIR/bin/logstash -f "${CONFIGDIR}/${REPONAME}.conf" > $LOGPATH/out.log 2> $LOGPATH/err.log &

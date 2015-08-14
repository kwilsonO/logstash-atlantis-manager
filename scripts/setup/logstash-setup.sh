LOGSTASHVER="logstash-1.5.3"
LOGSTASHDL="https://download.elastic.co/logstash/logstash/${LOGSTASHVER}.tar.gz"
LOGSTASHPATH="/root/atlantis-analytics"
REPONAME="logstash-atlantis-manager"
REPOPATH="${LOGSTASHPATH}/${REPONAME}"
LOGDIR="/var/log/atlantis/logstash"

wget "${LOGSTASHDL}"
tar -xzf "${LOGSTASHVER}.tar.gz"
rm "${LOGSTASHVER}.tar.gz"

if [ ! -d "$LOGDIR" ]; then 
	mkdir $LOGDIR
fi

LOGSTASHVER="logstash-1.5.3"
LOGSTASHPATH="/root/atlantis-analytics"
REPONAME="logstash-atlantis-manager"
REPOPATH="${LOGSTASHPATH}/${REPONAME}"
SCRIPTSDIR="${REPOPATH}/scripts"

sh "${SCRIPTSDIR}/install-java8.sh"
sh "${SCRIPTSDIR}/logstash-setup.sh"

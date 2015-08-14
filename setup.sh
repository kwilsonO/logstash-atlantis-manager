LOGSTASHVER="logstash-1.5.3"
LOGSTASHPATH="/root/atlantis-analytics"
REPONAME="logstash-atlantis-manager"
REPOPATH="${LOGSTASHPATH}/${REPONAME}"
SCRIPTSDIR="${REPOPATH}/scripts"
SETUPSCRIPTS="${SCRIPTSDIR}/setup"

for f in $SETUPSCRIPTS/*.sh; do

	echo "Executing setup script: $f"
	sh $f	

done

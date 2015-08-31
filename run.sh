LOGSTASHVER="logstash-1.5.3"
LOGSTASHPATH="/root/atlantis-analytics"
REPONAME="logstash-atlantis-manager"
REPOPATH="${LOGSTASHPATH}/${REPONAME}"
SCRIPTSDIR="${REPOPATH}/scripts"
RUNSCRIPTS="${SCRIPTSDIR}/run"

for f in $RUNSCRIPTS/*.sh; do

	echo "Executing run script: $f"
	bash $f

done

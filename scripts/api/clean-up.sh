#USED TO DELETE OLDER FILES
REPOPATH="/root/atlantis-analytics/logstash-atlantis-manager"
DATADIR="${REPOPATH}/data"
SUPDIR="${DATADIR}/supervisors"
CONDIR="${DATADIR}/containers"

for d in $CONDIR/; do
	if [ -d $d ]; then
		(ls -t $d | head -n 5; ls)|sort|uniq -u|xargs --no-run-if-empty rm
	fi
done

(ls -t $SUPDIR | head -n 5; ls)|sort|uniq -u|xargs --no-run-if-empty rm

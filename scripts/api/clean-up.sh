#USED TO DELETE OLDER FILES
REPOPATH="/root/atlantis-analytics/logstash-atlantis-manager"
DATADIR="${REPOPATH}/data"
SUPDIR="${DATADIR}/supervisors"
CONDIR="${DATADIR}/containers"

for d in $CONDIR/*; do
	if [ -d $d ]; then
		cd $d
		(ls -t | head -n 5; ls)|sort|uniq -u|xargs --no-run-if-empty rm 
	fi
done

cd $SUPDIR
(ls -t | head -n 5; ls)|sort|uniq -u|xargs --no-run-if-empty rm

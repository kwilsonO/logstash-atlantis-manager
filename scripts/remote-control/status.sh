myid="$(ps -ef | grep 'logstash-1.5.3' | grep -v grep | awk '{print $2}')"

if [ "${myid}" = "" ]; then 

	echo "No logstash process found."
else

	echo "[${myid}] atlantis-router logstash running."

fi

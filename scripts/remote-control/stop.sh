myid="$(ps -ef | grep "logstash" | grep -v grep | grep -v bash | awk '{print $2}')"

if [ "${myid}" = "" ]; then 

	echo "No logstash process found."
else

	echo "[${myid}] atlantis-router logstash running."

fi

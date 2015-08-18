pid=$(ps -ef | grep "logstash" | grep -v grep | awk '{print $2}')

if [ pid = "" ]; then 

	echo "No logstash process found."
else

	echo "[${pid}] atlantis-manager logstash running."

fi

echo "Stopping logstash..."
myid="$(ps -ef | grep "logstash-1.5.3" | grep -v grep | awk '{print $2}')"

if [ "${myid}" = "" ]; then 

	echo "No logstash process found."
else

	echo "Killing proccess pid: ${myid}..."

fi

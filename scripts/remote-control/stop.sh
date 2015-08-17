echo "Stopping logstash..."
kill -9 $(ps -ef | grep "logstash" | grep -v grep | awk '{print $2}')

myname="$(cat /root/atlantis-analytics/localname)"

echo "${myname} Run:"

echo "Starting logstash run script..."
sh /root/atlantis-analytics/logstash-atlantis-manager/run.sh

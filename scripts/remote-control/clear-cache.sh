myname="$(cat /root/atlantis-analytics/localname)"

echo "${myname} Status:"

echo "Deleting .sincedb file..."
rm /root/atlantis-analytics/logstash-atlantis-manager/.sincedb*

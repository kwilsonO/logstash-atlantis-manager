rm /root/atlantis-analytics/logstash-atlantis-manager/logstash-1.5.3/out.log
rm /root/atlantis-analytics/logstash-atlantis-manager/logstash-1.5.3/err.log
/root/atlantis-analytics/logstash-atlantis-manager/logstash-1.5.3/bin/logstash --debug -f /root/atlantis-analytics/logstash-atlantis-manager/config-files/logstash-manager-devbox.conf > out.log 2> err.log &

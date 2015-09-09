#script to get current disk space usage, etc

OUTPUT=$(df -m | grep -E '/dev/sda1|/dev/md0|tmpfs' | awk '{ print $1 "," $2 "," $3 "," $4 "," $5 "," $6 }')
#gets rid of newline
echo $OUTPUT

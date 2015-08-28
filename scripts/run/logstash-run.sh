LOGSTASHVER="logstash-1.5.3"
REPONAME="logstash-atlantis-manager"
REPOPATH="/root/atlantis-analytics"

#Instance Data gathering

URL="http://169.254.169.254/latest/meta-data"
INSTFULLHOST=$(curl ${URL}/hostname)
INSTID=$(curl ${URL}/instance-id)
INSTTYPE=$(curl ${URL}/instance-type)
INSTLOCALHST=$(curl ${URL}/local-hostname)
INSTLOCALIPV4=$(curl ${URL}/local-ipv4)
INSTMACADDR=$(curl ${URL}/mac)
INSTPUBHOST=$(curl ${URL}/public-hostname)
INSTPUBIP=$(curl ${URL}/public-ipv4)
INSTSECG=$(curl ${URL}/security-groups)
CONFIGSTR="filter { mutate { add_field => { 'host-full-hostname' => '${INSTFULLHOST}'  } add_field => { 'host-inst-id' => '${INSTID}' } add_field => { 'host-inst-type' => '${INSTTYPE}' } add_field => { 'host-local-hostname' => '${INSTLOCALHST}' } add_field => { 'host-local-ipv4' => '${INSTLOCALIPV4}' } add_field => { 'host-mac-addr' => '${INSTMACADDR}' } add_field => { 'host-pub-hostname' => '${INSTPUBHOST}' } add_field => { 'host-pub-ipv4' => '${INSTPUBIP}' } add_field => { 'host-sec-groups' => '${INSTSECG}' }  } }"
#Other Logstash

LOGSTASHPATH="${REPOPATH}/${REPONAME}"
LOGSTASHDIR="${LOGSTASHPATH}/${LOGSTASHVER}"
CONFIGDIR="${LOGSTASHPATH}/config-files"
LOGPATH="/var/log/atlantis/logstash"

export SINCEDB_DIR="$REPOPATH"

if [ -e "${LOGPATH}/out.log" ]; then
	rm "${LOGPATH}/out.log"
fi
if [ -e "${LOGPATH}/err.log" ]; then
	rm "${LOGPATH}/err.log"
fi

$LOGSTASHDIR/bin/logstash -e $CONFIGSTR -f "${CONFIGDIR}/${REPONAME}.conf" > $LOGPATH/out.log 2> $LOGPATH/err.log &

LOGSTASHVER="logstash-1.5.3"
REPONAME="logstash-atlantis-manager"
REPOPATH="/root/atlantis-analytics"
LOGSTASHPATH="${REPOPATH}/${REPONAME}"
LOGSTASHDIR="${LOGSTASHPATH}/${LOGSTASHVER}"
CONFIGDIR="${LOGSTASHPATH}/config-files"
LOGPATH="/var/log/atlantis/logstash"


#Instance Data gathering

URL="http://169.254.169.254/latest/meta-data"
declare -A INSTANCEDATA
INSTANCEDATA[INSTFULLHOST]="hostname"
INSTANCEDATA[INSTID]="instance-id"
INSTANCEDATA[INSTTYPE]="instance-type"
INSTANCEDATA[INSTLOCALHST]="local-hostname"
INSTANCEDATA[INSTLOCALIPV4]="local-ipv4"
INSTANCEDATA[INSTMACADDR]="mac"
INSTANCEDATA[INSTPUBHOST]="public-hostname"
INSTANCEDATA[INSTPUBIP]="public-ipv4"
INSTANCEDATA[INSTSECG]="security-groups"

if [ -e "${CONFIGDIR}/${REPONAME}.conf" ]; then
	echo "Removing old conf file..."
		rm "${CONFIGDIR}/${REPONAME}.conf"
	fi
	#copy fresh template
	echo "Copying fresh template and inserting values..."
	cp $CONFIGDIR/templates/$REPONAME.template.conf $CONFIGDIR/$REPONAME.conf

	for i in "${!INSTANCEDATA[@]}"
	do
		VAL=$(curl -s "${URL}/${INSTANCEDATA[${i}]}")
		#replace any spaces with colon
		VAL=$(echo $VAL | sed 's/ /:/g')
		SEDSTR="s/${i}/${VAL}/"
		sed -i $SEDSTR $CONFIGDIR/$REPONAME.conf
	done
					
		
#Other Logstash
export SINCEDB_DIR="$REPOPATH"

if [ -e "${LOGPATH}/out.log" ]; then
	rm "${LOGPATH}/out.log"
fi
if [ -e "${LOGPATH}/err.log" ]; then
	rm "${LOGPATH}/err.log"
fi

$LOGSTASHDIR/bin/logstash -f "${CONFIGDIR}/${REPONAME}.conf" > $LOGPATH/out.log 2> $LOGPATH/err.log &

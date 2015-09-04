URL="https://0.0.0.0:443"
LOGINURL="${URL}/login"
USAGEURL="${URL}/usage"
REPOPATH="/root/atlantis-analytics"
REPONAME="logstash-atlantis-manager"
REPODIR="${REPOPATH}/${REPONAME}"
USER=$(cat $REPOPATH/username.data)
PASSWORD=$(cat $REPOPATH/password.data)
SECRETPATH="${REPOPATH}/secret.data"
USAGEDATAPATH="${REPOPATH}/usage-cmd-out.data"
USERSECRETPARM="User=${USER}"
NOWTIME=$(date +%H-%M-%S)

#LOGIN and get secret
curl -s -k -XPOST "${LOGINURL}?User=${USER}&Password=${PASSWORD}" > $REPOPATH/login-output.tmp
MYSECRET=$(cat $REPOPATH/login-output.tmp | jq ".Secret" | sed 's/"//g') 

echo $MYSECRET > $SECRETPATH
rm $REPOPATH/login-output.tmp

#BUILD USER/SEcret PARM
USERSECRETPARM="${USERSECRETPARM}&Secret=${MYSECRET}"

#CURL API FOR USAGE DATA
curl -s -k -XGET "${USAGEURL}?${USERSECRETPARM}" > $USAGEDATAPATH

#OUTPUT A LIST OF HOSTS TO FILE
TMPOUT=$(cat $USAGEDATAPATH | jq '.Usage[].Host')
LENGTH=$(cat $USAGEDATAPATH | jq '.Usagep[].Host | length')

if [ $LENGTH == "0" ] || [ $TMPOUT == "jq: error: Cannot iterate over null" ]; then
	echo "No Supervisor Hosts found in Usage Data or error parsing..."
	exit 1
fi

cat $USAGEDATAPATH | jq '.Usage[].Host' > $REPOPATH/allhosts.tmp

if [ ! -d $REPODIR/data ]; then 
	mkdir $REPODIR/data
fi

if [ ! -d $REPODIR/data/supervisors ]; then
	mkdir $REPODIR/data/supervisors
else
	rm $REPODIR/data/supervisors/*
fi

#FILTER OUT CONTAINER DATA, ONLY GET TOTAL SUPERVISOR METRICS
TMPOUT=$(cat $USAGEDATAPATH | jq '.Usage[]')
LENGTH=$(cat $USAGEDATAPATH | jq '.Usage[] | length')
if [ $LENGTH == "0" ] || [ $TMPOUT == "jq: error: Cannot iterate over null" ]; then
	echo "Usage data empty/error when trying to get supervisor metrics..."
	exit 1 
fi

cat $USAGEDATAPATH | jq '.Usage[]' | jq 'del(.Containers)' | jq 'tostring' | sed 's/\\//g' | sed 's/"//g' > "${REPODIR}/data/supervisors/super${NOWTIME}.data"


if [ ! -d $REPODIR/data/containers ]; then
	mkdir $REPODIR/data/containers
fi
#LOOP THROUGH EACH HOST AND GRAB CONTAINER INFO
while read p; do
	tmp=$(echo "${p//\"}")

	if [ ! -d $REPODIR/data/containers/$tmp ]; then 
		mkdir $REPODIR/data/containers/$tmp
	else
		rm $REPODIR/data/containers/$tmp/*
	fi

	TMPOUT=$(cat $USAGEDATAPATH | jq ".Usage[${p}].Containers[]")
	LENGTH=$(cat $USAGEDATAPATH | jq ".Usage[${p}].Containers[] | length")
	if [ $LENGTH == "0" ] || [ $TMPOUT == *"jq: error: Cannot iterate over null"* ]; then
		echo "No data or error when getting info for: ${p}  ...."
		exit 1
	fi
	cat $USAGEDATAPATH | jq ".Usage[${p}].Containers[]" | jq 'tostring' | sed 's/\\//g' | sed 's/"//g' > "${REPODIR}/data/containers/${tmp}/containers${NOWTIME}.data"
done < $REPOPATH/allhosts.tmp

rm $REPOPATH/allhosts.tmp


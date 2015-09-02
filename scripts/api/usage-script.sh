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
cat $USAGEDATAPATH | jq '.Usage[].Host' > $REPOPATH/allhosts.tmp

if [ ! -d $REPODIR/data ]; then 
	mkdir $REPODIR/data
fi

if [ ! -d $REPODIR/data/supervisors ]; then
	mkdir $REPODIR/data/supervisors
fi

#FILTER OUT CONTAINER DATA, ONLY GET TOTAL SUPERVISOR METRICS
cat $USAGEDATAPATH | jq '.Usage[]' | jq 'del(.Containers)' | jq 'tostring' | sed 's/\\//g' | sed 's/"//g' > $REPODIR/data/supervisors/super.data


if [ ! -d $REPODIR/data/containers ]; then
	mkdir $REPODIR/data/containers
fi

#LOOP THROUGH EACH HOST AND GRAB CONTAINER INFO
while read p; do
	tmp=$(echo "${p//\"}")

	if [ ! -d $REPODIR/data/containers/$tmp ]; then 
		mkdir $REPODIR/data/containers/$tmp
	fi
	cat $USAGEDATAPATH | jq ".Usage[${p}].Containers[]" | jq 'tostring' | sed 's/\\//g' | sed 's/"//g' > $REPODIR/data/containers/$tmp/containers.data
done < $REPOPATH/allhosts.tmp

rm $REPOPATH/allhosts.tmp


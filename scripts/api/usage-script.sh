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

curl -k -XPOST "${LOGINURL}?User=${USER}&Password=${PASSWORD}" > $REPOPATH/login-output.tmp
cat $REPOPATH/login-output.tmp | jq ".Secret" > $SECRETPATH
export MYSECRET=$(cat $SECRETPATH)

rm $REPOPATH/login-output.tmp

USERSECRETPARM="${USERSECRETPARM}&Secret=${MYSECRET}"

curl -k -XGET "${USAGEURL}?${USERSECRETPARM}" > $USAGEDATAPATH

cat $USAGEDATAPATH | jq '.Usage[].Host' > $REPOPATH/allhosts.tmp

if [ ! -d $REPODIR/data ]; then 
	mkdir $REPODIR/data
fi

if [ ! -d $REPODIR/data/supervisors ]; then
	mkdir $REPODIR/data/supervisors
fi

cat $USAGEDATAPATH | jq '.Usage[]' | jq 'del(.Containers)' | jq 'tostring' | sed 's/\\//g' | sed 's/"//g' > $REPODIR/data/supervisors/super.data

while read p; do
	tmp=$(echo "${p//\"}")

	if [ ! -d $REPODIR/data/containers/$tmp]; then 
		mkdir $REPODIR/data/containers/$tmp
	fi	
	cat $USAGEDATAPATH | jq ".Usage[${p}].Containers[]" | jq 'tostring' | sed 's/\\//g' | sed 's/"//g' > $REPODIR/data/containers/$tmp/containers.data
done < $REPOPATH/allhosts.tmp

rm $REPOPATH/allhosts.tmp


#!/bin/bash

function _curl {
		curl -vsL --cookie cookie.txt --cookie-jar cookie.txt "$@"
		sleep 5
}

curl -sL localhost:8080 > /dev/null
while [ $? != 0 ]; do
	sleep 5
	curl -sL localhost:8080 > /dev/null
done

while [ "$(curl -sL localhost:8080 | grep 'Please wait')" != "" ]; do
	sleep 5
done

if [ ! -f /var/lib/jenkins/secrets/initialAdminPassword ]; then
	exit 0
fi

TOKEN=$(cat /var/lib/jenkins/secrets/initialAdminPassword)

_curl localhost:8080/j_acegi_security_check -d 'from=/&j_username=admin&j_password='$TOKEN > /dev/null

CRUMB=$(_curl localhost:8080/crumbIssuer/api/json -u admin:$TOKEN | grep -Eo '\w{64}')

BODY='{"dynamicLoad":true,"plugins":["cloudbees-folder","antisamy-markup-formatter","build-timeout","credentials-binding","timestamper","ws-cleanup","workflow-aggregator","github-branch-source","pipeline-github-lib","pipeline-stage-view","git","matrix-auth"]}'
_curl localhost:8080/pluginManager/installPlugins -H 'Content-Type: application/json' -H "Jenkins-Crumb: $CRUMB" -d "$BODY" > /dev/null

BODY='username=devops&password1=4linux&password2=4linux&fullname=devops@example.com'
_curl localhost:8080/setupWizard/createAdminUser -H "Jenkins-Crumb: $CRUMB" -d "$BODY" > /dev/null

CRUMB=$(_curl localhost:8080/crumbIssuer/api/json -u devops:4linux | grep -Eo '\w{64}')

BODY='rootUrl=http://172.27.11.10:8080/core:apply=&Submit=Save'
_curl localhost:8080/setupWizard/configureInstance -H "Jenkins-Crumb: $CRUMB" -d "$BODY" > /dev/null

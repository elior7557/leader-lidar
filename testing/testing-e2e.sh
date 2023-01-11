#This is e2e file for telementry it will download all dependencies


ARTIFACTORY_URL="http://13.38.228.183:8082/artifactory"
USER=$1
PASS=$2

mkdir test_files

#Get the lates snapshot of analytics For testing
analytics=$(curl -u $USER:$PASS -s "$ARTIFACTORY_URL/api/search/artifact?name=analytics*.jar&repos=libs-snapshot-local" |  jq '.results[-1].uri' -r)
download_uri=$(curl -u $USER:$PASS $analytics | jq '.downloadUri' -r) 
curl -u $USER:$PASS $download_uri -o test_files/analytics.jar

# Get the latest snap shot of telementry 
telemetry=$(curl -u $USER:$PASS -s "$ARTIFACTORY_URL/api/search/artifact?name=telemetry*.jar&repos=libs-snapshot-local" |  jq '.results[-1].uri' -r)
download_uri=$(curl -u $USER:$PASS $telemetry | jq '.downloadUri' -r) 
curl -u $USER:$PASS $download_uri -o test_files/telemetry.jar

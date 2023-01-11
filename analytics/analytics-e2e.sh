# E2E script for realse and feature branches in telemtry

ARTIFACTORY_URL="http://13.38.228.183:8082/artifactory"
USER=$1
PASS=$2

mkdir test_files

# Get Simulator.jar from artifactory
simulator=$(curl -u $USER:$PASS -s "$ARTIFACTORY_URL/api/search/artifact?name=simulator*.jar&repos=libs-snapshot-local" |  jq '.results[-1].uri' -r)
download_uri=$(curl -u $USER:$PASS $simulator | jq '.downloadUri' -r) 
curl -u $USER:$PASS $download_uri -o test_files/simulator.jar

SIMULATOR_PATH="./test_files/simulator.jar"
TELEMENTRY_PATH="./test_files/telemetry.jar"
ANALYICS_PATH="./target/analytics-99-SNAPSHOT.jar"

# #Get the lates Realse of telementry For testing
# When on relase
if [ $# -gt 2 ]; then
    BRANCH_VERSION=$3
    # Get telementry with latest version from current x.y
    telementry=$(curl -u $USER:$PASS -s "$ARTIFACTORY_URL/api/search/artifact?name=telemetry*.jar&repos=libs-release-local" |  grep -o "http://.*${BRANCH_VERSION}.*.jar" | tail -1)
    download_uri=$(curl -u $USER:$PASS $telementry | jq '.downloadUri' -r) 
    curl -u $USER:$PASS $download_uri -o test_files/telemetry.jar
else 
    echo "feature or master branch detected"
    #Get the lates snapshot of telemetry For testing
    telemetry=$(curl -u $USER:$PASS -s "$ARTIFACTORY_URL/api/search/artifact?name=telemetry*.jar&repos=libs-snapshot-local" |  jq '.results[-1].uri' -r)
    download_uri=$(curl -u $USER:$PASS $telemetry | jq '.downloadUri' -r) 
    curl -u $USER:$PASS $download_uri -o test_files/telemetry.jar
    
fi

# Run the test
java -cp $ANALYICS_PATH:$TELEMENTRY_PATH:$SIMULATOR_PATH com.lidar.simulation.Simulator

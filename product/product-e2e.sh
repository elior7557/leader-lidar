#This is e2e file for telementry it will download all dependencies


ARTIFACTORY_URL="http://13.38.228.183:8082/artifactory"

USER=$1
PASS=$2


mkdir test_files

# Get the latest snap shot of simulator
simulator=$(curl -u $USER:$PASS -s "$ARTIFACTORY_URL/api/search/artifact?name=simulator*.jar&repos=libs-snapshot-local" |  jq '.results[-1].uri' -r)
download_uri=$(curl -u $USER:$PASS $simulator | jq '.downloadUri' -r) 
curl -u $USER:$PASS $download_uri -o test_files/simulator.jar
 
#get the file to zip
ZIP_FILE=$(ls ./target/ | grep -v "SNAPSHOT" | grep "product")


unzip ./target/$ZIP_FILE
 
ANALYICS_PATH=$(ls | grep analytics)
TELEMENTRY_PATH=$(ls | grep telemetry)
SIMULATOR_PATH="./test_files/simulator.jar"

# Test 
java -cp $ANALYICS_PATH:$TELEMENTRY_PATH:$SIMULATOR_PATH com.lidar.simulation.Simulator

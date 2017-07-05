#!/bin/bash

serverNamesFile="uf.serverList.csv"
dockerComposeOut="../uf.docker-compose.yml"
scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
baseDir="${scriptDir}/.."
SPLUNK_HOME="/opt/splunkforwarder"

echo "version: '2'" >$dockerComposeOut
echo "services:"  >>$dockerComposeOut
echo "" >>$dockerComposeOut

egrep -v '^#' $serverNamesFile | egrep ',' | while read line 
do
  i=`echo $line | awk -F',' '{print $1}'` 
  group=`echo $line | awk -F',' '{print $2}'`
  ports=`echo $line | awk -F',' '{print $3}'`
  echo "  ${i}:" >> $dockerComposeOut
  echo "    image: splunkuf_${i}" >> $dockerComposeOut
  echo "    container_name: ${i}"   >> $dockerComposeOut
  echo "    hostname: ${i}"   >> $dockerComposeOut
  echo "    build:"    >> $dockerComposeOut
  echo "      context: ./buildDir"  >> $dockerComposeOut
  echo "      dockerfile: ${i}.Dockerfile" >> $dockerComposeOut
  echo "    environment:"  >> $dockerComposeOut
  echo "      SPLUNK_START_ARGS: --accept-license --answer-yes"   >> $dockerComposeOut
  echo "    volumes:"      >> $dockerComposeOut
  echo "      - ${baseDir}/buildDir/uf-specific/${i}/etc:${SPLUNK_HOME}/etc/" >> $dockerComposeOut
  echo "      - ${baseDir}/buildDir/uf-specific/${i}/var:${SPLUNK_HOME}/var/" >> $dockerComposeOut
  echo "    ports:"  >> $dockerComposeOut
  echo "      - ${ports}"   >> $dockerComposeOut
  echo "    labels:"  >> $dockerComposeOut
  echo "      splunk.cluster: \"${group}\" "  >> $dockerComposeOut
  echo "    networks:"  >> $dockerComposeOut
  echo "      splunk:"  >> $dockerComposeOut
  echo "        aliases:"  >> $dockerComposeOut
  echo "          - ${i}"  >> $dockerComposeOut
  echo "    restart: always"  >> $dockerComposeOut
  echo ""  >> $dockerComposeOut
  
# Now Create DockerFiles
  myDocker="../buildDir/${i}.Dockerfile"
  >| ${myDocker}
  echo "FROM splunk/universalforwarder:latest" >> $myDocker 
done

# common network
echo "networks:" >>$dockerComposeOut
echo "  splunk:" >>$dockerComposeOut


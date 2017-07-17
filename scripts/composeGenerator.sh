#!/bin/bash

# Expects input of either of 'es' OR 'uf' OR 'both'


case "$1" in
  es | ES )
    echo "Building compose for ES .. "
    products="es"
    ;;
  uf | UF )
    echo "Building compose for UF .. "
    products="uf"
    ;;
  *)
    echo "Building compose for both ES and UF ..."
    products="es uf"
    ;;
esac

dockerComposeOut="../splunk.docker-compose.yml"
scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
baseDir="${scriptDir}/.."
SPLUNK_HOME="/opt/splunk"
SPLUNK_ES_TAG="splunk/splunk:latest"
SPLUNK_UF_TAG="splunk/universalforwarder:latest"

# Clean any old yml files
rm -f $baseDir/*.yml
echo "version: '2'" >$dockerComposeOut
echo "services:"  >>$dockerComposeOut
echo "" >>$dockerComposeOut

# Alignment of echo is very important for docker-compose. DO NOT change this.
for product in `echo $products`
do
  echo "Writing compose file for $product .."
  serverNamesFile="${product}.serverList.csv"
  egrep -v '^#' $serverNamesFile | egrep ',' | while read line
  do
    i=`echo $line | awk -F',' '{print $1}'`
    group=`echo $line | awk -F',' '{print $2}'`
    ports=`echo $line | awk -F',' '{print $3}'`
    echo "  ${i}:" >> $dockerComposeOut
    echo "    image: splunkes_${i}" >> $dockerComposeOut
    echo "    container_name: ${i}"   >> $dockerComposeOut
    echo "    hostname: ${i}"   >> $dockerComposeOut
    echo "    build:"    >> $dockerComposeOut
    echo "      context: ./buildDir"  >> $dockerComposeOut
    echo "      dockerfile: ${i}.Dockerfile" >> $dockerComposeOut
    echo "    environment:"  >> $dockerComposeOut
    echo "      SPLUNK_START_ARGS: --accept-license --answer-yes"   >> $dockerComposeOut
    echo "    volumes:"      >> $dockerComposeOut
    echo "      - ${baseDir}/buildDir/${product}-specific/${i}/etc:${SPLUNK_HOME}/etc/" >> $dockerComposeOut
    echo "      - ${baseDir}/buildDir/${product}-specific/${i}/var:${SPLUNK_HOME}/var/" >> $dockerComposeOut
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
      >| ${myDocker}  # This will empty the previous files if any
      if [ $product = "es" ]; then
        echo "FROM ${SPLUNK_ES_TAG}" >> $myDocker
      elif [ $product = "uf" ]; then
        echo "FROM ${SPLUNK_UF_TAG}" >> $myDocker
      fi
  done
done

# common network
echo "networks:" >>$dockerComposeOut
echo "  splunk:" >>$dockerComposeOut

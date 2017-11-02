#!/bin/bash
# getkub.github.com
# Script to create Docker Compose file with dynamic hostnames and filesystem-mapping
# Expects input of either of 'es'/'uf'/'sta'. If NO options it will take both ES & UF in cluster mode

# es => Enterprise SPLUNK in cluster mode
# uf => Universal Forwarder
# sta => Enterprise Splunk in Standalone mode


case "$1" in
  es | ES )
    echo "Building compose for ES .. "
    products="es"
    ;;
  uf | UF )
    echo "Building compose for UF .. "
    products="uf"
    ;;
  sta | STA )
    echo "Building compose for STA (standalone ES) .. "
    products="sta"
    ;;
  *)
    echo "Building compose for both cluster ES and UF ..."
    products="es uf"
    ;;
esac

scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
baseDir=`dirname ${scriptDir}`
configsDir="${baseDir}/configs"
buildDir="${baseDir}/buildDir"
dockerComposeOut="${baseDir}/splunk.docker-compose.yml"

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
  serverNamesFile="${configsDir}/${product}.serverList.csv"
  if [ ! -f ${serverNamesFile} ]; then
    echo "File with server-hostnames and configs NOT found ! Quitting..."
	exit 100
  fi
  if [ $product = "es" ] || [ $product = "sta" ]; then
    product_tag=$SPLUNK_ES_TAG
  elif [ $product = "uf" ]; then
    product_tag=$SPLUNK_UF_TAG
  fi

  # if NOT a standlone do create compose with cluster details
  egrep -v '^#' $serverNamesFile| egrep -v '^hostname' | egrep ',' | while read line
  do
    i=`echo $line | awk -F',' '{print $1}'`
    group=`echo $line | awk -F',' '{print $2}'`
    ports=`echo $line | awk -F',' '{print $3}'`
    # The environment specific values
    myEnvFile="${buildDir}/${product}-specific/${i}/${i}.env"

    echo "  ${i}:" >> $dockerComposeOut
    echo "    image: ${product_tag} " >> $dockerComposeOut
    echo "    container_name: ${i}"   >> $dockerComposeOut
    echo "    hostname: ${i}"   >> $dockerComposeOut
    #echo "    build:"    >> $dockerComposeOut
    #echo "      context: ./buildDir"  >> $dockerComposeOut
    #echo "      dockerfile: ${i}.Dockerfile" >> $dockerComposeOut
    #echo "    environment:"  >> $dockerComposeOut
    #echo "      SPLUNK_START_ARGS: --accept-license --answer-yes"   >> $dockerComposeOut
    echo "    env_file:"  >> $dockerComposeOut
    echo "      - ${myEnvFile}"   >> $dockerComposeOut
    echo "    volumes:"      >> $dockerComposeOut
    echo "      - ${buildDir}/${product}-specific/${i}/etc:${SPLUNK_HOME}/etc/" >> $dockerComposeOut
    echo "      - ${buildDir}/${product}-specific/${i}/var:${SPLUNK_HOME}/var/" >> $dockerComposeOut
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
      >| ${myEnvFile}
      echo "SPLUNK_START_ARGS=--accept-license --answer-yes --no-prompt" >> $myEnvFile
      echo 'SPLUNK_BEFORE_START_CMD_1=version $SPLUNK_START_ARGS' >> $myEnvFile
      echo 'SPLUNK_BEFORE_START_CMD_2=edit user admin -password changed -role admin -auth admin:changeme' >> $myEnvFile
      echo "SPLUNK_BEFORE_START_CMD_3=cmd python -c'open(\"/opt/splunk/etc/.ui_login\", \"a\").close()'" >> $myEnvFile

  done
done

# common network
echo "networks:" >>$dockerComposeOut
echo "  splunk:" >>$dockerComposeOut

#!/bin/bash
# Creates App from template app per Splunk tier

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
baseDir="${scriptDir}/.."
configsDir="${baseDir}/configs"

# Output should in separate Directory
outputBase="/tmp/jinja"
projectName="docker_splunk"

bareAppDir="${outputBase}/${projectName}/bareApps"
buildDir="${outputBase}/${projectName}/buildDir"
rm -rf ${buildDir}
mkdir -p ${buildDir}

# Needs to ensure Specific CSV files for ES and UF are present
for product in `echo $products`
do
  appMappingFile="${configsDir}/${product}.appMapping.csv"
  if [ ! -r ${appMappingFile} ]; then
      echo "${appMappingFile} File not found!  Exiting without any action."
      exit 100
  fi
  serverApps="${buildDir}/${product}-specific"
  echo "Cleaning up $serverApps ...."
  rm -rf $serverApps 2>/dev/null
  mkdir -p $serverApps

  echo "Now building $serverApps ...."
  egrep -v '^#' $appMappingFile | egrep ',' | while read line
  do
    server=`echo $line | awk -F',' '{print $1}'`
    appWhiteList=`echo $line | awk -F',' '{print $2}'`
    appBlackList=`echo $line | awk -F',' '{print $3}'`
    mkdir -p ${serverApps}/${server}
    echo "Copying Apps for $server .."
    echo $appWhiteList |gawk -F'|' 'BEGIN { OFS="\n"}; {$1=$1; print $0}' | while read apps
    do
       mkdir -p ${serverApps}/${server}/etc/apps/
       cp -pr ${bareAppDir}/$apps ${serverApps}/${server}/etc/apps/ 2>/dev/null
       mkdir -p ${serverApps}/${server}/var/
    done

    # Now delete as per Blacklist
    echo $appBlackList |gawk -F'|' 'BEGIN { OFS="\n"}; {$1=$1; print $0}' | while read apps
    do
       rm -rf ${serverApps}/${server}/etc/apps/${apps} 2>/dev/null
    done

  done
done

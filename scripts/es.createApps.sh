#!/bin/bash

appMappingFile="es.appMapping.csv"
bareAppDir="../bareApps"
serverApps="../buildDir/es-specific"

echo "Cleaning up $serverApps ...."
rm -rf $serverApps 2>/dev/null
mkdir -p $serverApps

echo "Now building $serverApps ...."
egrep -v '^#' $appMappingFile | egrep ',' | while read line
do
  server=`echo $line | awk -F',' '{print $1}'`
  appList=`echo $line | awk -F',' '{print $2}'`
  mkdir -p ${serverApps}/${server}
  echo "Copying Apps for $server"
  echo $appList |gawk -F'|' 'BEGIN { OFS="\n"}; {$1=$1; print $0}' | while read apps
    do
      mkdir -p ${serverApps}/${server}/etc/apps/
      cp -pr ${bareAppDir}/$apps ${serverApps}/${server}/etc/apps/ 2>/dev/null
      mkdir -p ${serverApps}/${server}/var/
    done 
done

#!/bin/sh
##############
# Kyle LeBlanc 1/25/22
##############
# This script is intended to be used with the required LaunchDaemon (com.kandji.troubleshoot)
# LaunchDaemon will be triggered from any file being placed in /var/log/kandji/
# however, for this script to work this file must be called signal. If this is changed 
# then this script should be modified to reflect that. 
##############
# If an update to this script is needed then you should unload/load the LaunchDaemon again.
#
#

# Setting Default Variables
#kv=$(/usr/local/bin/kandji version)
# Kandji is not installed to let's make up a version #, if it is installed, uncomment the above and comment the below. 
kv="21.07"
logTime=$(date "+%Y-%m-%d")
count=0
collectionDir="/tmp/KandjiTroubleshooting_${logTime}"
mkdir $collectionDir
cd $collectionDir

#Making Default Logs
touch ./kandjiTroubleshootingLog.log
touch ./agent.log
touch ./networkHardware.log

#Making during logs
mkdir ./during
cd ./during
  touch ./d_wifi.log
  touch ./d_airport.log
  touch ./d_ifconfig.log
  touch ./d_bluetooth.log

#Making after logs
mkdir $collectionDir/after
cd ../after
  touch ./a_wifi.log
  touch ./a_airport.log
  touch ./a_ifconfig.log
  touch ./a_bluetooth.log

logAction() {
  logTime=$(date "+%Y-%m-%d - %H:%M:%S:")
  echo "$logTime" "$1" >> $collectionDir/kandjiTroubleshootingLog.log
}

logAction "*********************************"
logAction "BEGIN LOG COLLECTION"
logAction "*********************************"
logAction "Current Kandji Version: $kv"

CheckStatus() {
    status=$(networksetup -getinfo "$1" | tail -n +2)
    echo "Status of $1 is:" >> "${collectionDir}/networkHardware.log"
    echo " " >> "${collectionDir}/networkHardware.log"
    echo "$status" >> "${collectionDir}/networkHardware.log"
    echo " " >> "${collectionDir}/networkHardware.log"
}

# The below loop will run every 10 seconds while /var/log/kandji/signal is present. 

while [ -f /var/log/kandji/signal ]
do

  logAction "*********************************"
  logAction "Signal File Found; Collecting Data... "

    #The following logs will only be collected once per "signlaing", these are unlikely to change much during this time and likely won't need to be collected continuously
    while [ $count == 0 ]
    do
      logAction "START Single Log Collections Per Signaling"
      logAction "Collecting Airport Logs..."
      /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -s -I > "${collectionDir}/during/d_airport.log"

      logAction "Collecting ifconfig Log..."
      ifconfig > "${collectionDir}/during/d_ifconfig.log"

      logAction "Collecting Bluetooth Logs... "
      system_profiler SPBluetoothDataType > "${collectionDir}/during/d_bluetooth.log"

      logAction "END Single Log Collections Per Signaling"
      ((count++))
    done


  logAction "Collecting WiFi Logs... "
  tail -n 100 /var/log/wifi.log > "${collectionDir}/during/d_wifi.log"

  logAction "Collecting Recent Kandji Logs..."
  # If Kandji is installed uncomment the below line to pull actual logs, currently creates an empty log file. 
  #/usr/local/bin/kandji logs --no-format --last 10000 > $collectionDir/agent.log

  logAction "Collecting Network Service Status..."
  time=$(date "+%Y-%m-%d-%H:%M:%S:")
  echo "$time" >> "${collectionDir}/networkHardware.log"
  networksetup -listallnetworkservices | tail -n +2 | while read line; do CheckStatus "$line"; done

  sleep 10
done

logAction "*********************************"
logAction "Signal File Removed; Connection Restored; Continuing..."
logAction "*********************************"
logAction "Collecting After Logs for analysis comparisons..."
logAction "Sending Last Network Services Report now that Service is Restored..."

echo "*********************************" >> "${collectionDir}/networkHardware.log"
echo "Network Services Now that Kandji Connection is Restored:" >> "${collectionDir}/networkHardware.log"
networksetup -listallnetworkservices | tail -n +2 | while read line; do CheckStatus "$line"; done

logAction "Collecting WiFi Logs After... "
tail -n 100 /var/log/wifi.log > "${collectionDir}/after/a_wifi.log"

logAction "Collecting Airport Logs After... "
/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -s -I > "${collectionDir}/after/a_airport.log"

logAction "Collecting ifconfig Logs After... "
ifconfig > "${collectionDir}/after/a_ifconfig.log"

logAction "Collecting Bluetooth Logs After... "
system_profiler SPBluetoothDataType > "${collectionDir}/after/a_bluetooth.log"

logAction "*********************************"

logAction "Zipping Logs..."
zip -qr $collectionDir.zip $collectionDir

logAction "Uploading Logs..."
# We do not have an active/live server to upload to so the below is commented out, if an active server/location is available this should be updated. 
#/usr/bin/curl -s -T $collectionDir.zip -u username:PASSWORDHERE ftp://your.ftp-server-here.com/$collectionDir.zip

logAction "Cleaning Up..."
rm -rf $collectionDir

logAction "*********************************"
logAction "END LOG COLLECTION"
logAction "*********************************"

exit 0
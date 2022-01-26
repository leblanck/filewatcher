#!/bin/sh
##############
# Kyle LeBlanc 1/25/22
##############
# This should be run as root to handle LaunchDaemon requirements. 


echo "Making Kandji Shared Directory..."
mkdir /Users/Shared/kandji

echo "Moving troubleshoot.sh..."
mv ./troubleshoot.sh /Users/Shared/kandji/troubleshoot.sh

echo "Changing troubleshoot.sh permissions..."
chmod +x /Users/Shared/kandji/troubleshoot.sh

echo "Moving LaunchDaemon..."
mv ./com.kandji.troubleshoot.plist /Library/LaunchDaemons/com.kandji.troubleshoot.plist

echo "Changing LaunchDaemon permissions..."
chmod 600 /Library/LaunchDaemons/com.kandji.troubleshoot.plist
chown root /Library/LaunchDaemons/com.kandji.troubleshoot.plist

echo "Loading LaunchDaemon..."
launchctl load /Library/LaunchDaemons/com.kandji.troubleshoot.plist
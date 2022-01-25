#!/bin/sh
##############
# Kyle LeBlanc 1/25/22
##############
# This should be run as root to handle LaunchDaemon requirements. 

mkdir /Users/Shared/kandji
mv ./troubleshoot.sh /Users/Shared/kandji/troubleshoot.sh
chmod +x /Users/Shared/kandji/troubleshoot.sh

mv ./com.kandji.troubleshoot.plist /Library/LaunchDaemons/com.kandji.troubleshoot.plist

launchctl load /Library/LaunchDaemons/com.kandji.troubleshoot.plist
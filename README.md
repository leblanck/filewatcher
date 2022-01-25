# filewatcher
macOS File/Directory Watcher

## About

This is used to create a LaunchDaemon that will monitor a directory for existance of a file (any file). While that file is present, execute the LaunchDaemon until that file is no longer present in the watched directory. 

For the sake of this use-case, we are monitoring specifically for `/var/log/kandji/signal`

If this directory or filename change, then this script and LaunchDaemon must be updated to reflect that. 

When executed, `troubleshoot.sh` will create a timestamped log collection folder in `/tmp/` called `KandjiTroubleshooting_$DATE`. This will have a folder structure like the following:

```
/tmp/KandjiTroubleshooting_$DATE
├── README.md <- You are here
├── after
│   ├── a_airport.log
│   ├── a_bluetooth.log
│   ├── a_ifconfig.log
│   ├── a_wifi.log
├── during
│   ├── d_airport.log
│   ├── d_bluetooth.log
│   ├── d_ifconfig.log
│   ├── d_wifi.log
├── agent.log
├── kandjiTroubleshootingLog.log
├── networkHardware.log
```

This will be zipped and sent to an ftp server that is set in `troubleshoot.sh`. The original folder will be deleted but the .zip will remain after we are finished. 

## Installation

1. Clone this repo
2. `cd filewatch`
3. `sudo chmod +x install.sh; sudo ./install.sh`

## Misc.
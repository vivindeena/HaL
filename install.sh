#!/bin/bash

user=$(id -un)

sudo rm -rf /Users/$user/.hal
sudo rm -f /usr/local/bin/hal.sh 
launchctl remove com.wow.hal

mkdir /Users/$user/.hal
chmod +x hal.sh
chmod +x halauto.sh

cp hal.sh /Users/$user/.hal/
cp halauto.sh /Users/$user/.hal/
cp -R HaL.app /Applications

sudo cp hal.sh /usr/local/bin/hal

cp com.wow.hal.plist /Users/$user/Library/LaunchAgents/
launchctl load -w /Users/$user/Library/LaunchAgents/com.wow.hal.plist
launchctl start com.wow.hal

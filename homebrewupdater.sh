#!/bin/bash

# 1. Get the target app from Jamf Parameter 4
# This allows us to reuse the script for Node, rclone, etc.
targetApp="$4"

if [[ -z "$targetApp" ]]; then
    echo "No target app specified in Parameter 4. Exiting."
    exit 1
fi

# 2. Get the currently logged-in user
currentUser=$(stat -f "%Su" /dev/console)

# 3. Determine Homebrew path
if [[ -d "/opt/homebrew" ]]; then
    brewPath="/opt/homebrew/bin/brew"
    brewBase="/opt/homebrew"
elif [[ -d "/usr/local/Homebrew" ]]; then
    brewPath="/usr/local/bin/brew"
    brewBase="/usr/local"
else
    echo "Homebrew not found. Skipping."
    exit 0
fi

# 4. Ensure ownership (Standard User fix)
chown -R "$currentUser":staff "$brewBase"

# 5. Run Update and Upgrade for the specific app
echo "Checking for $targetApp updates for $currentUser..."
sudo -u "$currentUser" "$brewPath" update

isOutdated=$(sudo -u "$currentUser" "$brewPath" outdated --formula | grep -w "$targetApp")

if [[ -n "$isOutdated" ]]; then
    echo "Update found for $targetApp. Upgrading..."
    sudo -u "$currentUser" "$brewPath" upgrade "$targetApp"
    echo "$targetApp successfully updated."
else
    echo "$targetApp is already up to date."
fi

exit 0
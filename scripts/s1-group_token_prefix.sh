#!/bin/bash

# 1. Get the local Computer Name
COMP_NAME=$(scutil --get ComputerName)

# 2. Determine the Token based on the Prefix
# This matches the prefix (case-insensitive) and assigns the token. Default catchall token for names not defined
case "$COMP_NAME" in
    [Ii][Tt]-*)        TOKEN="INSERTGROUPTOKEN" ;;
    [Hh][Rr]-*)       TOKEN="INSERTGROUPTOKEN" ;;
    [Ff][Ii][Nn]-*)       TOKEN="INSERTGROUPTOKEN" ;;
    *)              TOKEN="DEFAULTGROUPTOKEN" ;;
esac

# 3. Write the selected token to the registration-token file
echo "$TOKEN" > "/Library/Application Support/JAMF/Waiting Room/com.sentinelone.registration-token"

# 4. Run the installer using the package name passed in Jamf Parameter $4
# (Jamf Parameters 1-3 are reserved by Jamf)
PKG_PATH="/Library/Application Support/JAMF/Waiting Room/$4"

if [ -f "$PKG_PATH" ]; then
    echo "Installing $4 for computer $COMP_NAME using token for prefix."
    /usr/sbin/installer -pkg "$PKG_PATH" -target /
else
    echo "Error: Installer package not found at $PKG_PATH"
    exit 1
fi
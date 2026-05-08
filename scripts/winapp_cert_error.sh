#!/bin/bash

# 1. Target the Microsoft Windows App process
APP_NAME="Windows App"
TARGET_CERT="certauth.login.microsoftonline.us"

echo "Checking if $APP_NAME is running..."

# 2. Force quit the app if it's active
if pgrep -x "$APP_NAME" > /dev/null; then
    echo "Closing $APP_NAME to release keychain locks..."
    killall "$APP_NAME"
    sleep 2
fi

# 3. Identify current logged-in user to target their specific keychain
CURRENT_USER=$(stat -f%Su /dev/console)
USER_KEYCHAIN="/Users/$CURRENT_USER/Library/Keychains/login.keychain-db"

echo "Cleaning keychain for user: $CURRENT_USER"

# 4. Delete the Identity/Certificate entries
# We use -Z to target the SHA-1 hash if possible, but -c (common name) is more reliable for automation
security delete-certificate -c "$TARGET_CERT" "$USER_KEYCHAIN" 2>/dev/null

# 5. Delete any associated password/token entries
security delete-internet-password -s "$TARGET_CERT" "$USER_KEYCHAIN" 2>/dev/null
security delete-generic-password -l "$TARGET_CERT" "$USER_KEYCHAIN" 2>/dev/null

echo "Remediation complete. The user will be prompted to sign in fresh upon next launch."

exit 0
#!/bin/bash

# 1. Get the currently logged-in user
currentUser=$(stat -f "%Su" /dev/console)

# 2. Check if the user is 'root' or empty (happens if no one is logged in)
if [[ -z "$currentUser" ]] || [[ "$currentUser" == "root" ]]; then
    echo "<result>No User Logged In</result>"
    exit 0
fi

# 3. Define the Brew Path
brewPath="/opt/homebrew/bin/brew"

# 4. Check if brew exists
if [[ -x "$brewPath" ]]; then
    # Run the list command AS the logged-in user
    list=$(sudo -u "$currentUser" "$brewPath" list --formula | tr '\n' ',' | sed 's/^/,/;s/$/,/')
    echo "<result>$list</result>"
else
    echo "<result>Not Installed</result>"
fi
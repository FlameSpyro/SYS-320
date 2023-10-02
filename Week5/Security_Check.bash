#!/bin/bash

# Story: Update security scanner for a giant list of rules. If the rule doesnt match then run a remediation

# Function Check: Compare and Remidiate

function checks() {
	
	if [[ $2 != $3 ]]
	then
		echo "I'm sorry, the $1 isnt compliant. This should be: $2, currently its: $3"
		echo "The remediation would be: $4"
	else
		echo "$1 works. The policy is currently set to: $3."
	fi
}


# Ensure IP forwarding is disabled

ipforwarding=$(sysctl net.ipv4.ip_forward | awk '{print $3}')
checks "ip forwarding" "0" "${ipforwarding}" "Set net.ipv4.ip_forward = 0 in /etc/sysctl.conf."


# Ensure ICMP redirects are not accepted

ICMPredirects=$(sysctl net.ipv4.conf.all.secure_redirects | awk '{print $3}')
checks "ICMP redirects" "0" "${ICMPredirects}" "Set  net.ipv4.conf.all.secure_redirects = 0 in /etc/sysctl.conf"


# Check that long list of file  permissions
# Doing this made it easier for copy/paste to since they have similar structure with some alternations

crontabperms=$(stat -c %a /etc/crontab)
checks "Crontab permissions" "644" "${crontabperms}" "chown root:root /etc/crontab and chmod og-rwx /etc/crontab"

cronhourly=$(stat -c %a /etc/cron.hourly)
checks "Cron.hourly permissions" "755" "${cronhourly}" "chown root:root /etc/cron.houly and chmod og-rwx /etc/cron.hourly"

crondaily=$(stat -c %a /etc/cron.daily)
checks "Cron.daily permissions" "755" "${crondaily}" "chown root:root /etc/cron.daily and chmod og-rwx /etc/crondaily"

cronweekly=$(stat -c %a /etc/cron.weekly)
checks "Cron.weekly permissions" "755" "${cronweekly}" "chown root:root /etc/cron.weekly and chmod og-rwx /etc/cron.weekly"

cronmonthly=$(stat -c %a /etc/cron.monthly)
checks "Cron.monthly permissions" "755" "${cronmonthly}" "chown root:root /etc/cron.monthly and chmod og-rwx /etc/cron.monthly"

passpolicy=$(stat -c %a /etc/passwd)
checks "passwd policy" "644" "${passpolicy}" "chown root:root /etc/passwd and chmod 644 /etc/passwd"

shadowpolicy=$(stat -c %a /etc/shadow)
checks "shadow policy" "640" "${shadowpolicy}" "chown root:shadow /etc/shadow"

grouppolicy=$(stat -c %a /etc/group)
checks "group policy" "644" "${grouppolicy}" "chown root:root /etc/group"

gshadowpolicy=$(stat -c %a /etc/gshadow)
checks " gshadow policy" "640" "${gshadowpolicy}" "chown root:shadow /etc/gshadow"

passwdpolicy=$(stat -c %a /etc/passwd)
checks "passwd- policy" "644" "${passwdpolicy}" "chown root:root /etc/passwd-"

shdo=$(stat -c %a /etc/shadow-)
checks "shadow- policy" "640" "${shdo}" "chown root:shadow /etc/shadow-"

group=$(stat -c %a /etc/group-)
checks "group- policy" "644" "${group}" "chown root:root /etc/group-"

gshadow=$(stat -c %a /etc/gshadow-)
checks "gshadow- policy" "640" "${gshadow}" "chown root:shadow /etc/gshadow-"


# Leagacy Entries to ensure no + entries exist in the respective file

checks "Legacy '+' entries in /etc/passwd" "$(grep '^+:' /etc/passwd)" "" "Edit /etc/passwd and remove any lines starting with '+'"

checks "Legacy '+' entries in /etc/shadow" "$(grep '^+:' /etc/shadow)" "" "Edit /etc/shadow and remove any lines starting with '+'"

checks "Legacy '+' entries in /etc/group" "$(grep '^+:' /etc/group)" "" "Edit /etc/group and remove any lines starting with '+'"


# Ensure root is the only UID 0 account

UID0Users=$(cat /etc/passwd | awk -F: '($3 == 0) {print $1}')
checks "users with UID 0" "root" "{$UID0Users}" "Remove users other then root with UID of 0"

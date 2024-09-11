#!/bin/bash
set -e

groups=("audio" "video" "storage" "network" "bluetooth" "input")

current_user=$(whoami)

group_exists() {
	local group=$1
	getent group "$group" >/dev/null 2>&1
}

check_and_add_group() {
	local user=$1
	local group=$2

	if group_exists "$group"; then
		if id -nG "$user" | grep -qw "$group"; then
			echo "Skipping $group: $user is already part of this group"
		else
			echo "Adding $group group to $user"
			sudo usermod -aG "$group" "$user"
			if [ $? -eq 0 ]; then
				echo "$user has been added to the $group group successfully"
			else
				echo "Failed to add $user to the $group group"
			fi
		fi
	else
		echo "The group $group does not exist"
	fi
}

for group in "${groups[@]}"; do
	check_and_add_group "$current_user" "$group"
done

echo "Group membership update process completed"

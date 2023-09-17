#!/bin/bash

# Menu for the admin, VPN, and Security funtions

function invalid_opt() {

    echo ""
    echo "invalid option"
    echo ""
    sleep 2




}

function menu() {

	#clears the screen
	clear

	echo "[1] Check for UID of 0"
	echo "[2] Check the last 10 logged in users"
	echo "[3] List open network sockets"
	echo "[4] See currently logged users"
	echo "[5] Exit"

	read -p "please enter a choice above: " choice

	case "$choice" in

		1) id root
		;;

		2) last | head -n 10
		;;

		3) ss -a |less

		;;

                4) w

                ;;

                5) exit

                ;;

		*)

			invalid_opt
			menu

		;;



           esac


}

menu

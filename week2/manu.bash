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

	echo "[1] Admin Menu"
	echo "[2] Security Menu"
	echo "[3] Exit"
	read -p "please enter a choice above: " choice

	case "$choice" in

		1) admin_menu
		;;

		2)
		;;

		3) exit

		;;

		*)

			invalid_opt
			menu

		;;



           esac


}

# Admin menu

function admin_menu() {

 clear

        echo "[L]ist Running Processes"
        echo "[N]etwork Sockets"
        echo "[V]PN menu"
	echo "[4] exit"
        read -p "please enter a choice above: " choice

	case "$choice" in

                L|l) ps -ef |less
                ;;

                N\n) netstat -an --inet |less
                ;;

                V|v) vpn

                ;;


		4) exit

		;;
                *)

			invalid_opt
			admin_menu
                ;;





	esac

}

function vpn() {

	clear
	echo"[A]dd a peer"
	echo"[D]elete a peer"
	echo"[B]ack to admin menu"
	echo"[M]ain menu"
	echo"[E]xit"
	read -p "Please select an option: " choice

	case "$choice" in

                A|a) 
			bash peer.bash
			tail -6 wg0.conf |less
                ;;

                D|d) manage-users.bash
		     # Create a prompt for the user to delete
		     # Call the manage-user.bash passing proper information
		     
                ;;

                B|b) admin_menu

                ;;

                M|m) manu

                ;;
                E}e) exit

                ;;
                *)

                        invalid_opt
                        vpn
                ;;

	esac

vpn
}

# Call function
menu

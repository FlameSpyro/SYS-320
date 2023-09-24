  GNU nano 6.2                                                                                                              week4_Parsing.bash                                                                                                                        
#!/bin/bash


# Story: Firewall main menu. Calls to parse script depending on option where the magic happens.

function firewall_menu() {

 clear

        echo "[i]p tables"
        echo "[C]isco"
        echo "[W]indows Firewall"
        echo "[M]ac OS X"
        echo "[G]ithub file"
        echo "[4]Exit"
        read -p "Select a service you would like to modify " choice

        case "$choice" in

                I|i) bash parsing_files.bash -i
                ;;

                C|c) bash parsing_files.bash -n
                ;;

                W|w) bash parsing_files.bash -v
                ;;

                M|m) bash parsing_files.bash -m
                ;;

                G|g) bash parsing_files.bash -g
                ;;

                4) exit

                ;;

                *)

                        echo "Invalid option"
                        firewall_menu
                ;;





        esac

}



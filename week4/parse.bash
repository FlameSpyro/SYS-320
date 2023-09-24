#!/bin/bash

# Story: Checks if the .rules file exist then depening on the option curls the file to appeal to the chosen firewall using a switch.

# Create File Variable

gfile="/tmp/targetedthreats.csv"
pFile="/tmp/emerging-drop.suricata.rules"
select=""

# Filename variable
# Check for existing config file / if we want to override
if [[ -f "${pFile}" ]]
then 
        # Prompt if we need to overwrite the file
        echo "The file ${pFile} already exists."
        echo -n "Do you want to overwrite it? [y|N]"
        read to_overwrite

        if [[ "${to_overwrite}" == "N" || "${to_overwrite}" == "" || "${to_overwrite}" == "n"  ]]
        then
                echo "Proceeding..."
        elif [[ "${to_overwrite}" == "y" ]]
        then
                echo "Updating the emergingthreats file..."
                wget  https://rules.emergingthreats.net/blockrules/emerging-drop.suricata.rules -O /tmp/emerging-drop.suricata.rules

        # If they don't specify y/N then error
        else
                echo "Invalid value"
                exit 1
        fi

else
         echo "Downloading emerginthreats file..."
         wget  https://rules.emergingthreats.net/blockrules/emerging-drop.suricata.rules -O /tmp/emerging-drop.suricata.rules

fi


# This switch uses the option from week4 menu file to define the select var

while getopts "icwmg:" OPTION
do

        case ${OPTION} in
                i)
                        select="iptables"
                        ;;
                c)
                        select="cisco"
                        ;;
                w)
                        select="windowsf"
                        ;;
                m)
                        select="macx"
                        ;;
                g)
                        select="github"
                        ;;
                *)
                        select="Thats... not an option"
                        exit 1
                        ;;

        esac
done


# Redid this aspect to simplify (as much as possible)
# Checks if github file already exist like before

if [[ $select == "github" ]]
then
                 echo "Downloading github threats file..."
                 wget  https://raw.githubusercontent.com/botherder/targetedthreats/master/targetedthreats.csv -O /tmp/targetedthreats.csv
                 echo "class-map match-any BAD_URL" | tee bad_URL.csv
                 curl -s $gfile | grep ",domain," | cut -d',' -f3 | sort -u | while read -r domain
                 do
                        echo "Match protocol http host \"$domain\"" | tee -a bad_URL.csv
                 done

else

        # Greps file and depending on the option it will change a firewall rule and throw it in a proper file
        egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.0/[0-9]{1,2}' /tmp/emerging-drop.suricata.rules | sort -u | tee badIPs.txt
        for eachIP in $(cat badIPs.txt)
        do

                case $select in

                                "iptables")
                                         echo "iptables -A INPUT -s ${eachIP} -j DROP" | tee -a badIPs.table
                                ;;

                                 "cisco") 
                                        echo "access-list inbound_acl deny ip ${eachIP} any" | tee -a badIP.cisco
                                ;;

                                 "windowsf")
                                         echo "netsh advfirewall firewall add rule name\"Block ${eachIP}\" dir=in action-block remoteip=${eachIP}" | tee -a badIP.windowsf
                                ;;

                                 "macx")
                                         echo "sudo pfctl -t blocklist -T add ${eachIP}" | tee -a badIP.macx
                                ;;

                                 *)
                                         echo "Thats... not an option"
                                ;;

      esac

  done
fi

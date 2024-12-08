#!/bin/bash

myIP=$(bash ipAddr.bash)


# Todo-1: Create a helpmenu function that prints help for the script
function Help() {

   echo "************************HELP MENU*****************************"
   echo ""
   echo "-n: Add -n as an argument for this script to use nmap"
   echo " -n external: External NMAP scan"
   echo " -n internal: Internal NMAP scam"
   echo "-s: Add -s as an argument for this script to use ss"
   echo " -s external: External ss(Netstat) scan"
   echo " -s internal: Internal ss(Netstat) scan"
   echo ""
   echo "Usage: bash $0 -n/s external/internal"
   echo ""
   echo "**************************************************************"
}

# Return ports that are serving to the network
function ExternalNmap(){
  rex=$(nmap "${myIP}" | awk -F"[/[:space:]]+" '/open/ {print $1,$4}' )
  echo "$rex"
}

# Return ports that are serving to localhost
function InternalNmap(){
  rin=$(nmap localhost | awk -F"[/[:space:]]+" '/open/ {print $1,$4}' )
  echo "$rin"
}


# Only IPv4 ports listening from network
function ExternalListeningPorts(){

# Todo-2: Complete the ExternalListeningPorts that will print the port and application
# that is listening on that port from network (using ss utility)
elpo=$(ss -ltpn | awk -F"[[:space:]:(),]+" '/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/ && !/127\.0\.0\./ {print $5,$9}' | tr -d "\"")
echo "$elpo"
}


# Only IPv4 ports listening from localhost
function InternalListeningPorts(){
ilpo=$(ss -ltpn | awk  -F"[[:space:]:(),]+" '/127.0.0./ {print $5,$9}' | tr -d "\"")
echo "$ilpo"
}



# Todo-3: If the program is not taking exactly 2 arguments, print helpmenu
if [ ! ${#} -eq 2 ]; then
Help
exit;
fi
# Todo-4: Use getopts to accept options -n and -s (both will have an argument)
# If the argument is not internal or external, call helpmenu
# If an option other then -n or -s is given, call helpmenu
# If the options and arguments are given correctly, call corresponding functions
# For instance: -n internal => will call NMAP on localhost
#               -s external => will call ss on network (non-local)
while getopts "n:s:" option
do
	case $option in
	n)
	   if [ ${OPTARG} == "external" ]; then
		ExternalNmap
	fi

           if [ ${OPTARG} == "internal" ]; then
                InternalNmap
	fi


	;;
	s)
           if [ ${OPTARG} == "external" ]; then
                 ExternalListeningPorts
        fi

           if [ ${OPTARG} == "internal" ]; then
                InternalListeningPorts
        fi

	;;
	esac
done;



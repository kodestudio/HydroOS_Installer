#!/bin/bash 
install(){
	echo "To begin installation, your computer must be connected to the internet. Follow the wizard to connect to an existing network."
		echo "Select your connection type:"
		net=("Wifi" "Ethernet")
	select nt in ${net[*]}; do
		case $nt in
			"Wifi") wifidct
					break;;
			"Ethernet") ethernet
					break;;
			 *) echo "Invalid option, please try again."
						;;
		esac
	done
}
wifidct(){
	echo "Detecting wifi interface . . ."
	wlan=($(ls /sys/class/net | grep wl*))
	i=1
	for j in ${wlan[@]};do
		echo "${i}) ${j}"
		i=$((i+1))
	done
	read -r  -p  'Wifi interface detected, please enter your wifi interface:' c
	ifconfig $c up
	if [ $?=0 ] 
	then
		echo "Scanning for wifi network . . ."
		nmcli -t -f SIGNAL,SSID device wifi list | sort -nr
		read -rp  'Please enter your Wifi SSID. If you cannot find it, please check whether your wifi connection is available or not.' ssid
		wifitype=("WPA" "WPA-PSK" "WEP" "OPEN WIFI")
		select wft in ${wifitype[@]};do
			case $wft in
			"WPA"|"WPA-PSK"|"WEP") read -r -p 'Enter password: ' password
									echo -n "Is it a hidden network? [y/n] "
									read ans 
									if [ ${ans}=="y" ] || [ ${ans}=="Y" ] 
									then
										nmcli device wifi connect "${ssid}" password  "${password}" ifname $c hidden yes
									elif [ ${ans}=="n" ] || [ ${ans}=="N" ] 
									then
										nmcli device wifi connect "${ssid}" password "${password}" ifname $c
									else
										echo "Invalid option, please try again."
										wifidct
									fi
									break;;
			"OPEN WIFI")echo "Connect to the chosen Wifi? [y/n]"
						if [ ${ans}=="y" ] || [ ${ans}=="Y" ] 
									then
										nmcli device wifi connect "${ssid}" ifname $c hidden yes
									elif [ ${ans}=="n" ] || [ ${ans}=="N" ] 
									then
										nmcli device wifi connect "${ssid}" ifname $c | 2&>1 >/dev/null
									else
										echo "Invalid option, please try again."
										wifidct
									fi
						nmcli device wifi connect "${ssid}"  ifname $c
						break;;
						
			*) echo "Invalid option."
				;;
			esac
		done

elif [ $?!=0 ]
then

	echo "Unexpected error encoutered, please try again. Probably your network interface doesn't exist."
	echo -n "Enter your Wifi interface again: "
	read c
	ifconfig $c up 
	wifichk
fi
	}
wifichk(){
	if [ $?!=0 ] 
	then 
	echo "Unexpected error encoutered, please config wifi again."
	wifidct
fi
	}
ethernet(){
	echo "Detecting your Ethernet interface..."
	ethernetinf=($(ls /sys/class/net/ | grep ^e))
	i=1
	for j in ${ethernetinf[@]}; do
		echo "${i}) ${j}"
		i=$((i+1))
	done
	echo "Enter your Ethernet interface:"
	read $ethernet
}
echo "------------------ H Y D R O   O S ------------------"
echo "|         Welcome to the HydroOS Installer!         |"
echo "|            What do you want me to do?             |"
option=("Install" "Reboot" "Exit")
echo "-----------------------------------------------------"
select opt in ${option[*]};
do
case $opt in 
"Install")
	install
	break;;
"Reboot") echo "Under maintainance..."
	break;;
"Exit") echo "Exiting..."
	break;;
*) echo "Invalid option, please try again.";;
esac
done


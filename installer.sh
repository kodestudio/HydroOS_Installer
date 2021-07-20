#!/bin/bash 
install(){
	echo "Connecting to a network"
		echo "Select connection type:"
		net=("Wifi" "Ethernet")
	select nt in ${net[*]}; do
		case $nt in
			"Wifi") wifidct
					break;;
			"Ethernet") ethernet
					break;;
			 *) echo "Invalid Option! Try Again"
						;;
		esac
	done
}
wifidct(){
	echo "Detecting your wifi network interface . . ."
	wlan=($(ls /sys/class/net | grep wl*))
	i=1
	for j in ${wlan[@]};do
		echo "${i}) ${j}"
		i=$((i+1))
	done
	read -r  -p  'Enter your wlan network interface:' c
	ifconfig $c up
	if [ $?=0 ] 
	then
		echo "Scanning wifi network:"
		nmcli -t -f SIGNAL,SSID device wifi list | sort -nr
		read -rp  'enter your Wifi SSID: ' ssid
		wifitype=("WPA" "WPA-PSK" "WEP" "OPEN WIFI")
		select wft in ${wifitype[@]};do
			case $wft in
			"WPA"|"WPA-PSK"|"WEP") read -r -p 'Enter wifi password: ' password
									echo -n "Is it a hidden network ?? [y/n] "
									read ans 
									if [ ${ans}=="y" ] || [ ${ans}=="Y" ] 
									then
										nmcli device wifi connect "${ssid}" password  "${password}" ifname $c hidden yes
									elif [ ${ans}=="n" ] || [ ${ans}=="N" ] 
									then
										nmcli device wifi connect "${ssid}" password "${password}" ifname $c
									else
										echo "Invalid Option! Try to config wifi again"
										wifidct
									fi
									break;;
			"OPEN WIFI")echo "Getting connect to your wifi..."
						if [ ${ans}=="y" ] || [ ${ans}=="Y" ] 
									then
										nmcli device wifi connect "${ssid}" ifname $c hidden yes
									elif [ ${ans}=="n" ] || [ ${ans}=="N" ] 
									then
										nmcli device wifi connect "${ssid}" ifname $c | 2&>1 >/dev/null
									else
										echo "Invalid Option! Try to config wifi again"
										wifidct
									fi
						nmcli device wifi connect "${ssid}"  ifname $c
						break;;
						
			*) echo "Invalid Options"
				;;
			esac
		done

elif [ $?!=0 ]
then

	echo "Try again! May be your network interface doesn't exist!!!"
	echo -n "Enter your wifi interface again: "
	read c
	ifconfig $c up 
	wifichk
fi
	}
wifichk(){
	if [ $?!=0 ] 
	then 
	echo "Try to config wifi again"
	wifidct
fi
	}
ethernet(){
	echo "Detecting your Ethernet interface"
	ethernetinf=($(ls /sys/class/net/ | grep ^e))
	i=1
	for j in ${ethernetinf[@]}; do
		echo "${i}) ${j}"
		i=$((i+1))
	done
	echo "Enter your Ethernet network interface:"
	read $ethernet
}
echo  "Welcome to HydroOS Installer v1.0"
echo "--------------HydroOS------------------"
echo "What do you want me to do?"
option=("Install" "Update" "Upgrade" "Reboot" "Exit")
select opt in ${option[*]};
do
case $opt in 
"Install")
	install
	break;;
"Update") echo "LOL";
	break;;
"Upgrade") echo "Nothing"
	break;;
"Reboot") echo "Bye bye"
	break;;
"Exit") echo "Bla Bla"
	break;;
*) echo "Invalid Option! Please try again!!!";;
esac
done


#!/bin/bash 
install(){
	echo "Do you want to connect to a network [y/n]?"
	read a
	if [$a=="y" || $a="N"] 
then
		echo "Select connection type:"
		net=("Wifi","Ethernet")
	select nt in ${net[*]}; do
		case $nt in
			"Wifi") wifi
					break;;
			"Ethernet") ethernet
					break;;
			*) echo "Invalid Option! Try Again"
						;;
		esac
	done
else [$a=="n" || $a=="N"]
			echo "We'll move to partion disk![y/n]"
			read b
		if [$b=="y"]
then
			partition
else [$b=="n"]
			exit
	fi
}
update(){}
upgrade(){}
quit(){}
wifidct(){
	echo "Detecting your wifi network interface . . ."
	wlan=( /sys/class/net | grep wl*))
	i=1
	for j in ${wlan[@]};do
		echo "${i}) ${j}"
		i=$((i+1))
	done
	echo "Enter your wlan network interface:"
		read $c
	ifconfig $c up 
	if [$? != 0] 
then
	echo "Try again! May be your network interface doesn't exist!!!"
	echo "Enter your wifi interface again:"
	read $c
	ifconfig $c up
	wifichk
else [$?==0]
		echo "enter your Wifi SSID:"
		read ssid
		wifitype=("WPA","WPA-PSK","WEP","OPEN WIFI", "HIDDEN WIFI")
		select wft in ${wifitype[@]};do
			case $wft in
			"WPA"|"WPA_PSK"|"WEP") echo "Enter wifi password:"
									read password
									nmcli device wifi connect $ssid password $password ifname $c
									break;;
			"OPEN WIFI")echo "Getting connect to your wifi..."
						nmcli device wifi connect $ssid  ifname $c
						break;;
			"HIDDEN WIFI") echo "Enter wifi password
			*) echo "Invalid Options"
				;;
			esac
		done
	}
wifichk(){
	if [$?!=0] 
	then 
	echo "Try to config wifi again"
	wifidct
	}
ethernet(){
	echo "Detecting your Ethernet interface"
	ethernetinf=$((ls /sys/class/net/ | grep ^e))
	i=1
	for j in ${ethernetinf[@]}; do
		echo "${i}) ${j}"
		i=$((i+1))
	done
	echo "Enter your Ethernet network interface:"
	read $ethernet

echo  "Welcome to HydroOS Installer v1.0"
echo "--------------HydroOS------------------"
echo "What do you want me to do?"
option=("Install" "Update" "Upgrade" "Reboot" "Exit")
select opt in ${option[*]};
do
case $opt in 
"Install") install
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

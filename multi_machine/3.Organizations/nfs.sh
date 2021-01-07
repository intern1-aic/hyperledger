#!/bin/bash
echo "----------------------------------------------------------------------------"
echo "-------------------------NFS Installation-----------------------------------"
echo "----------------------------------------------------------------------------"
echo "which type you want to install"

echo " __________________________________________"
echo "|                                          |"
echo "| 1.nfs-kernel-server (for server side)    |"
echo "| 2.nfs-common (for client side)           |"
echo "|__________________________________________|"
echo ""
echo "please select either 1 or 2"
read type_install

if [ $type_install == 1 ]; then
	
	sudo apt update && sudo apt -y upgrade && sudo apt install nfs-kernel-server
	sudo mkdir /repo && sudo chown -R $USER: /repo && sudo chmod -R 777 /repo
	echo "enter the number of clients: "
	read number_of_clients
	touch clients.txt
	count=1
	while [ $count -le $number_of_clients ]; do
		echo "enter the ip address of the $count-th client:"
		read ip_client
		if [[ $ip_client =~ ^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$  ]]; then
			echo $ip_client >> clients.txt
			count=$((count+1))
		else
			echo "ip address is not valid..please enter a valid ip address"
		fi		
	done

	while IFS= read -r line; do
	                  
		str_line="/repo $line(rw,sync,no_subtree_check)"
		echo "$str_line" | sudo tee -a /etc/exports
	done < clients.txt

	sudo exportfs -ra
	echo "setting of nfs server is completed.."

	rm clients.txt

elif [ $type_install == 2 ]; then

	check="false"
	sudo apt update && sudo apt -y upgrade && sudo apt install nfs-common
	sudo mkdir /repo
	while [ $check != "true" ]; do
		
		echo "enter the ip address of the server "
		read server_ip
		if [[ $server_ip =~ ^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$  ]]; then
			str_client="$server_ip:/repo /repo nfs defaults,timeo=900,retrans=5,_netdev 0 0"
		echo "$str_client" | sudo tee -a /etc/fstab
		sudo mount -a 
		sudo mount $server_ip:/repo /repo
		echo "setting of nfs client is completed"
		check="true"
		else
			echo "ip address is not valid..please enter a valid ip address"

		fi
	done
	

else
	echo "invalid selection"
	exit 1
fi


#this script can be used to clear all the existing docker images, kubernetes config files, kubernetes packages, and hyperledger fabric

#after cleaning the script will automatically install the latest versions of kubernetes, kubeadm, kubectl, docker and hyperledger fabric

#given two type of choices 

#user can make a choice 

#choice 1 is cleans all the existing config files, packages and images that related to docker, kuberntes, and hyperledger fabric

  echo "$(tput setaf 1)    _   _   _   _____      ____   _____   _        _   _   _   ____  _____     _      _       _       _____   ____   $(tput setaf 3)"
  echo "$(tput setaf 2)   | | | | | | |_   _|    | __ ) | ____| | |      | | | \ | | ( ___||_   _|   / \    | |     | |     | ____| |  _ \  $(tput setaf 3)"
  echo "$(tput setaf 3)   | | | | | |   | |   _  |  _ \ |  _|   | |      | | |  \| | \ \__   | |    / _ \   | |     | |     |  _|   | |_) | $(tput setaf 3)"
  echo "$(tput setaf 4)   | | | | | |   | |  |_| | |_) || |___  | |___   | | | |\  | _\_  )  | |   / ___ \  | |___  | |___  | |___  |  _ <  $(tput setaf 3)" 
  echo "$(tput setaf 5)   |_| |_| |_|   |_|      |____/ |_____| |_____|  |_| |_| \_||____/   |_|  /_/   \_\ |_____| |_____| |_____| |_| \_\ $(tput setaf 3)"


echo "##########################################################################################################################"
echo "==================================================All in One Script======================================================="
echo "##########################################################################################################################"


echo ""
echo ""


$user_choice #variable that stores the choice of the user. It should be 1 or 2 or 3

echo "Please select an option from the following"

echo "=========================================="
echo "$(tput setaf 9)1. all clean "
echo ""
echo "2. Install kubernetes and hypeledger-fabric 2.0"
echo ""
echo "3. reset kubernetes$(tput setaf 3)"
echo "=========================================="

echo ""
echo ""

echo " $(tput setaf 2)plese select an option. (you can choose either '1' or '2' or '3' $(tput setaf 3)"

read user_choice

confirm="y"



function clear_all()
{
	count=0
	kuber=0
	docker=0
	git=0
	curl=0
	go=0
	wget=0
	node=0
			echo " $(tput setaf 2)This script will remove the existing version of kubernetes, docker, nodejs, npm, and hypeledger-fabric $(tput setaf 6)"
			echo "######################################################################################################"

			which kubeadm

		if [ $? -eq 0 ]; then
		    kuber=1
		    echo $confirm | sudo kubeadm reset
			echo $confirm | sudo apt-get purge kubeadm 
			echo $confirm | sudo apt-get purge kubectl
			echo $confirm | sudo apt-get purge kubelet
			echo $confirm | sudo apt-get purge kubernetes-cni
			echo $confirm | sudo apt-get purge kube* 
			echo $confirm | sudo apt-get autoremove  
			echo $confirm | sudo rm -rf ~/.kube
			count=$((count+1)) 


		else
			echo " $(tput setaf 1)kubernetes packages are not found!!!!!!!!!!!!! $(tput setaf 6)"
			
			
		fi
		which docker

		if [ $? -eq 0 ]; then
			docker=1
			sudo chmod 666 /var/run/docker.sock
			echo $confirm | sudo docker kill $(docker ps -q)
			echo $confirm | sudo docker rm -f $(docker ps -aq)
			echo $confirm | sudo docker rmi -f $(docker images -q)


			echo $confirm | sudo rm -rf ~/.composer
			echo $confirm | sudo rm -rf ~/.fabric-tools
			echo $confirm | sudo rm /usr/local/bin/docker-compose
			echo $confirm | sudo apt-get remove docker-ce
			echo $confirm | sudo apt-get purge docker.io
			echo $confirm | sudo apt-get purge docker-compose
			echo $confirm | sudo snap remove --purge docker
			count=$((count+1)) 

		else
			echo "$(tput setaf 1)docker images are not found!!!!!!!!!!!!!!$(tput setaf 6)"
			


		fi

		which git

		if [ $? -eq 0 ]; then
			git=1
			echo $confirm | sudo apt-get remove git
			echo $confirm | sudo apt-get remove --auto-remove git
			echo $confirm | sudo apt-get purge git
			echo $confirm | sudo apt-get purge --auto-remove git
			count=$((count+1)) 

		else
			echo "$(tput setaf 1)git is not found!!!!!!!!!!!!!!$(tput setaf 6)"

		fi

		
		which curl
		if [ $? -eq 0 ]; then
			curl=1
			echo $confirm | sudo apt-get remove --auto-remove curl
			echo $confirm | sudo apt-get purge curl
			count=$((count+1)) 

		else

			echo "$(tput setaf 1)curl is not found!!!!!!!!!!$(tput setaf 6)"

		fi


		which wget

		if [ $? -eq 0 ]; then
			wget=1
			echo $confirm | sudo apt-get remove wget
			echo $confirm | sudo apt-get autoremove wget
			echo $confirm | sudo apt-get purge wget
			echo $confirm | sudo apt-get autoremove --purge wget
			count=$((count+1)) 

		else

			echo "$(tput setaf 1)wget is not found!!!!!!!!!!$(tput setaf 6)"

		fi


		which go

		if [ $? -eq 0 ]; then
			go=1
			echo $confirm | sudo apt-get remove golang-go
			echo $confirm | sudo apt-get remove --auto-remove golang-go
			echo $confirm | sudo apt-get purge golang-go
			count=$((count+1)) 

		else

			echo "$(tput setaf 1)golang-go is not found!!!!!!!!!!$(tput setaf 6)"

		fi

		which node

		if [ $? -eq 0 ]; then
			node=1
			echo $confirm | sudo apt-get remove nodejs
			echo $confirm | sudo apt-get remove npm
			count=$((count+1)) 

		else

			echo "$(tput setaf 1)nodejs and npm are not found!!!!!!!!!!$(tput setaf 6)"

		fi

		if [ $count -eq 7 ]; then

		

			echo ""
			echo ""
			echo " $(tput setaf 3)All existing packages are removed... $(tput setaf 6)"
			echo "-------------------------------------"

			

			echo ""


		else
			

			if [ $kuber -eq 1 ]; then
				echo " $(tput setaf 3)kuberntes removed successfully $(tput setaf 6)"
			else
				which kubeadm
				if [ $? -ne 0 ]; then
					echo "$(tput setaf 1)kubernetes not found..$(tput setaf 6)"
					echo "please check if you installed before..."
				else
					echo "$(tput setaf 1)kuberntes can't be removed..$(tput setaf 6)"
				fi
			fi  



			if [ $docker -eq 1 ]; then
				echo " $(tput setaf 3)docker and docker images are removed successfully $(tput setaf 6)"
			else
				which docker
				if [ $? -ne 0 ]; then
					echo "$(tput setaf 1)docker not found..$(tput setaf 6)"
					echo "please check if you installed before..."
				else
					echo "$(tput setaf 1)docker can't be removed..$(tput setaf 6)"
				fi
			fi



			if [ $curl -eq 1 ]; then
				echo " $(tput setaf 3)curl removed successfully $(tput setaf 6)"
			else
				which curl
				if [ $? -ne 0 ]; then
					echo "$(tput setaf 1)curl not found..$(tput setaf 6)"
					echo "please check if you installed before..."
				else
					echo "$(tput setaf 1)curl can't be removed..$(tput setaf 6)"
				fi
			fi



			if [ $wget -eq 1 ]; then
				echo " $(tput setaf 3)wget removed successfully $(tput setaf 6)"
			else
				which wget
				if [ $? -ne 0 ]; then
					echo "$(tput setaf 1)wget not found..$(tput setaf 6)"
					echo "please check if you installed before..."
				else
					echo "$(tput setaf 1)wget can't be removed..$(tput setaf 6)"
				fi
			fi

			if [ $git -eq 1 ]; then
				echo " $(tput setaf 3)git removed successfully $(tput setaf 6)"
			else
				which git
				if [ $? -ne 0 ]; then
					echo "$(tput setaf 1)git not found..$(tput setaf 6)"
					echo "please check if you installed before..."
				else
					echo "$(tput setaf 1)git can't be removed..$(tput setaf 6)"
				fi
			fi

			if [ $go -eq 1 ]; then
				echo " $(tput setaf 3)golang-go removed successfully $(tput setaf 6)"
			else
				which go
				if [ $? -ne 0 ]; then
					echo "$(tput setaf 1)golang-go not found..$(tput setaf 6)"
					echo "please check if you installed before..."
				else
					echo "$(tput setaf 1)golang-go can't be removed..$(tput setaf 6)"
				fi
			fi


			if [ $node -eq 1 ]; then
				echo " $(tput setaf 3)nodejs and npm removed successfully $(tput setaf 6)"
			else
				which node
				if [ $? -ne 0 ]; then
					echo "$(tput setaf 1)node js and npm are not found..$(tput setaf 6)"
					echo "please check if you installed before..."
				else
					echo "$(tput setaf 1)node js and npm can't be removed..$(tput setaf 6)"
				fi
			fi

	    fi


}

function reset_kubernetes()
{
	#echo "enter 'y' for confirmations"
	echo ""
	which kubeadm

	if [ $? -eq 0 ]; then
		echo "resetting kubernetes..............................."
		echo $confirm | sudo kubeadm reset > temp.txt

		if [ $? -eq 0 ]; then
		  echo "[reset] WARNING: Changes made to this host by 'kubeadm init' or 'kubeadm join' will be reverted."
	      echo "[preflight] Running pre-flight checks"
	      echo "[reset] Stopping the kubelet service"
	      echo "[reset] Unmounting mounted directories in '/var/lib/kubelet'"
	      echo "[reset] Deleting contents of config directories: [/etc/kubernetes/manifests /etc/kubernetes/pki]"
	      echo "[reset] Deleting files: [/etc/kubernetes/admin.conf /etc/kubernetes/kubelet.conf /etc/kubernetes/bootstrap-kubelet.conf /etc/kubernetes/controller-manager.conf /etc/kubernetes/scheduler.conf]"
	      echo "[reset] Deleting contents of stateful directories: [/var/lib/kubelet /var/lib/dockershim /var/run/kubernetes /var/lib/cni]"

      if [ -e /etc/cni/net.d/* ]; then

        sudo rm -R /etc/cni/net.d/*

        if [ $? -eq 0 ]; then

          echo "contents of /etc/cni/net.d/ removed successfully..."

        else
        	echo "cannot find existing configuration files in /etc/cni/net.d/*"
        	echo "skippig..................................................."
           
        fi

      else

        echo "cannot find existing configuration files in /etc/cni/net.d/*"
        echo "skippig..................................................."

      fi

      
      
      if [ -e $HOME/.kube ]; then

          rm -R $HOME/.kube

          if [ $? -eq 0 ]; then

             echo "$HOME/.kube removed successfully"

          else

         echo "cannot find existing configuration files in /$HOME/.kube"
        echo "skippig..................................................."

          fi
      else

        echo "cannot find existing configuration files in /$HOME/.kube"
        echo "skippig..................................................."

          rm -f ./temp.txt

      fi
    
  else
    echo " $(tput setaf 1)cannot reset kubeadm..package not found.. $(tput setaf 6)"

fi
fi
	

}

function install_kubernetes()
{
	docker=0
	kuber=0
	go=0
	wget=0
	curl=0
	git=0
	node=0
	count=0

	echo " $(tput setaf 3)=================================================================================================== $(tput setaf 6)"
	echo " $(tput setaf 99)Installing kubernetes, docker, docker-compose, hypeledger-fabric 2.0, wget, curl, git and golang-go $(tput setaf 6)"
	echo " $(tput setaf 3)=================================================================================================== $(tput setaf 6)"

	echo ""
	sudo apt update

	which git
	if [ $? -ne 0 ]; then
			git=1
			
			echo $confirm | sudo add-apt-repository ppa:git-core/ppa
			echo $confirm | sudo apt-get install git
			count=$((count+1)) 

		else
			echo " $(tput setaf 3)git is already installed..!!!!!!!!!!!!!! $(tput setaf 6)"
			


		fi

	which curl
	if [ $? -ne 0 ]; then
			curl=1
			
			echo $confirm | sudo apt install curl
			count=$((count+1)) 

		else
			echo " $(tput setaf 3)curl is already installed..!!!!!!!!!!!!!! $(tput setaf 6)"
			


		fi



	which wget
	if [ $? -ne 0 ]; then
			wget=1
			
			echo $confirm | sudo apt-get install wget
			count=$((count+1)) 

		else
			echo " $(tput setaf 3)wget is already installed..!!!!!!!!!!!!!! $(tput setaf 6)"
			


		fi


	

	which go
	if [ $? -ne 0 ]; then
			go=1
			echo $confirm | sudo apt install golang-go
			export GOPATH=$HOME/go
			export PATH=$PATH:$GOPATH/bin
			count=$((count+1)) 

		else
			echo " $(tput setaf 3)golang-go is already installed..!!!!!!!!!!!!!! $(tput setaf 6)"
			


		fi


	which node
	if [ $? -ne 0 ]; then
			node=1
			sudo curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
			echo $confirm | sudo apt install nodejs
			count=$((count+1)) 

		else
			echo " $(tput setaf 3)node js and npm are already installed..!!!!!!!!!!!!!! $(tput setaf 6)"
			


		fi


	which docker
	if [ $? -ne 0 ]; then
			docker=1
			echo $confirm | sudo apt install docker.io
			echo $confirm | sudo apt install docker-compose
			echo $confirm | sudo chmod 666 /var/run/docker.sock
			echo $confirm | sudo systemctl start docker
			echo $confirm | sudo usermod -a -G docker $USER




			#echo $confirm | curl -sSL https://bit.ly/2ysbOFE | bash -s -- 2.0.1 1.4.6 0.4.18
			#curl -sSL http://bit.ly/2ysbOFE | bash -s -- 1.4.9 1.4.9 0.4.21

			count=$((count+1)) 

		else
			echo " $(tput setaf 3)docker is already installed..!!!!!!!!!!!!!! $(tput setaf 6)"
			


		fi

	        echo " _______________________________________________________________________________________________________"
			echo "|                                                                                                       |"
			echo "| please note:                                                                                          |"
			echo "| fabric binaries can be installed from internet or from tar files..                                    |"
			echo "| please confirm?                                                                                       |"  
			echo "|                                                                                                       |"
			echo "| 1. Through Internet                                                                                   |"
			echo "| 2. From tar files- Note: for this 'requirements.tar.gz' should be present on current working directory|"
			echo "|     (Remember when using local tar files, it may take a few minutes to unzip the docker images)       |"
			echo "|_______________________________________________________________________________________________________|"

		
			read source

			if [ $source -eq 1 ]; then

				
				docker pull k8s.gcr.io/kube-proxy:v1.19.3
				docker pull k8s.gcr.io/kube-scheduler:v1.19.3
				docker pull k8s.gcr.io/kube-apiserver:v1.19.3 
				docker pull k8s.gcr.io/kube-controller-manager:v1.19.3 
				docker pull k8s.gcr.io/etcd:3.4.13-0
				docker pull k8s.gcr.io/coredns:1.7.0
				docker pull k8s.gcr.io/pause:3.2
				docker pull hyperledger/fabric-couchdb:0.4.15
				sudo curl -sSL https://bit.ly/2ysbOFE | bash -s -- 2.0.1 1.4.6 0.4.18
				cp -rf ./fabric-samples/bin .
				rm -rf ./fabric-samples
				#sg docker -c "curl -sSL https://bit.ly/2ysbOFE | bash -s -- 2.0.0 1.4.6 0.4.18 -s"

			elif [ $source -eq 2 ]

			then
				
				docker load --input ./requirements.tar.gz
				docker load --input ./couchdb.tar.gz

				# if [ -e ./bin ]; then

				# 	rm -rf ./bin
				# fi


				# #sudo curl -sSL https://bit.ly/2ysbOFE | bash -s -- 2.0.1 1.4.6 0.4.18
				# #sg docker -c "curl -sSL https://bit.ly/2ysbOFE | bash -s -- 2.0.0 1.4.6 0.4.18 -s"
				# tar -xvzf hyperledger-fabric-linux-amd64-2.0.1.tar.gz
				# tar -xvzf hyperledger-fabric-ca-linux-amd64-1.4.6.tar.gz -C bin
				# mv ./bin/bin/* ./bin
				# rm -rf ./bin/bin
				# rm -rf ./config
			fi



	which kubeadm
	if [ $? -ne 0 ]; then
			kuber=1
			echo $confirm | sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add

			echo $confirm | sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"

			echo $confirm | sudo apt install kubeadm kubelet kubectl kubernetes-cni

			

			count=$((count+1)) 

		else
			echo " $(tput setaf 3)kubernetes are already installed..!!!!!!!!!!!!!! $(tput setaf 6)"
			


		fi


	if [ $count -eq 7 ]; then

		echo ""
		echo " $(tput setaf 3)all packages are installed successfully $(tput setaf 6)"
		echo ""
		echo "-----------------------------------------------------------------------------------------------------------------------"

	# else
	# 	which docker 
	# 	if [ $? -eq 0 ]; then
	# 		echo "docker and hypeledger-fabric 2.0 are installed successfully"

	# 	else
	# 	fi

	# 	which curl 
	# 	if [ $? -eq 0 ]; then
	# 		curl=1
	# 	fi

	# 	which go 
	# 	if [ $? -eq 0 ]; then
	# 		go=1
	# 	fi

	# 	which wget 
	# 	if [ $? -eq 0 ]; then
	# 		wget=1
	# 	fi

	# 	which git
	# 	if [ $? -eq 0 ]; then
	# 		git=1
	# 	fi

	# 	which node 
	# 	if [ $? -eq 0 ]; then
	# 		node=1
	# 	fi

	# 	which kubedm
	# 	if [ $? -eq 0 ]; then
	# 		kuber=1
	# 	fi

	fi

}


if [ $user_choice -eq 1 ]
then

	clear_all

elif [ $user_choice -eq 2 ]

then
	
	install_kubernetes

elif [ $user_choice -eq 3 ]

then
	reset_kubernetes
fi


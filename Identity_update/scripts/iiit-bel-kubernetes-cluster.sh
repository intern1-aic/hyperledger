#! /bin/sh
##This script is used to deploy a kubernetes cluster 
##before running the script docker and kubernetes should be installed with in the machine....
#rbac.yml should be saved on the current directory
#first checks a cluster already exists
#if a cluster is already exists, removes that first 

#the kubernetes join token is saved in /repo/join-token.txt file
#make sure that the shared folder named as /repo in root directory
begin=`date +"%T"`
begin_nano=`date +"%N"`


  echo "$(tput setaf 1)    _   _   _   _____      ____   _____   _         _    _      _       ____   _____   _____   ____   " 
  echo "$(tput setaf 2)   | | | | | | |_   _|    | __ ) | ____| | |       | \  / |    / \     ( ___| |_   _| | ____| |  _ \  "
  echo "$(tput setaf 3)   | | | | | |   | |   _  |  _ \ |  _|   | |       |  \/  |   / _ \    \ \_     | |   |  _|   | |_) | "
  echo "$(tput setaf 4)   | | | | | |   | |  |_| | |_) || |___  | |___    | |  | |  / ___ \   _\_  )   | |   | |___  |  _ <  "
  echo "$(tput setaf 5)   |_| |_| |_|   |_|      |____/ |_____| |_____|   |_|  |_| /_/   \_\ |____/    |_|   |_____| |_| \_\ $(tput setaf 6)"


echo "=============================================================================================================="
echo "=============================================================================================================="
echo "======================================checking for existing cluser============================================"
echo "=============================================================================================================="

echo "y" | sudo kubeadm reset >temp.txt

if [ $? -eq 0 ]; then

        echo "[reset] WARNING: Changes made to this host by 'kubeadm init' or 'kubeadm join' will be reverted."
        echo "[preflight] Running pre-flight checks"
        echo "[reset] Stopping the kubelet service"
        echo "[reset] Unmounting mounted directories in '/var/lib/kubelet'"
        echo "[reset] Deleting contents of config directories: [/etc/kubernetes/manifests /etc/kubernetes/pki]"
        echo "[reset] Deleting files: [/etc/kubernetes/admin.conf /etc/kubernetes/kubelet.conf /etc/kubernetes/bootstrap-kubelet.conf /etc/kubernetes/controller-manager.conf /etc/kubernetes/scheduler.conf]"
        echo "[reset] Deleting contents of stateful directories: [/var/lib/kubelet /var/lib/dockershim /var/run/kubernetes /var/lib/cni]"

      if [ -e /etc/cni/net.d/ ]; then

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

echo "--------------------------------------------------------------------------------------------------------------"
echo "=============================================================================================================="
echo "====================================Initializing kubernetes cluseter=========================================="
echo "=============================================================================================================="

echo "please wait for a few moments........"

echo "this may take a few moments..............."

#clear the shared folder

sudo rm -rf /repo/*
cp -R ./bin /repo
#first disabling swap memory ....
sudo swapoff -a
#initializing kubeadm..
sudo kubeadm init > temp.txt

if [ ! -e join-token.txt ]; then

  touch join-token.txt
fi

sudo kubeadm token create --print-join-command 2> /dev/null >join-token.txt

sudo cp ./join-token.txt /repo/join-token.txt

rm -f temp.txt
rm -f join-token.txt

if [ $? -ne 0 ]; then 
  exit 1

fi

echo "=============================================================================================================="
echo "join token for worker nodes is saved on the shared folder 'join-token.txt' "

echo "--------------------------------------------------------------------------------------------------------------"

echo "you can use the join-token to join more worker nodes into the cluster........................................."
echo "=============================================================================================================="

#creating directory for kubernetes cluster

  # rm -R $HOME/.kube
  mkdir -p $HOME/.kube
echo "=============================================================================================================="
echo "created directory for kubernetes cluster"
echo "=============================================================================================================="

#copying configuration files from /etc/kubernetes/admin.conf to $HOme/.kube/config
echo "=============================================================================================================="
echo "copying files" 
echo "=============================================================================================================="

echo "enter 'y' for proceed"

   echo "y"|  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
   sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "copying files completed......"
echo "=============================================================================================================="

#deploying a pod network into the cluster
#using calico cni for the network

echo "=============================================================================================================="
echo "==================================deploying calico cni to the cluster========================================="
echo "=============================================================================================================="

#deploying pod network

   kubectl apply -f ./calico.yaml 

    if [ $? -eq 0 ]; then

    echo "$(tput setaf 3)deploying pod network is completed"

    echo "fetching configuration files"

    sh fetch_config.sh > temp.txt
    if [ $? -eq 0 ]; then
      echo "$(tput setaf 2) configurations updated"
    else
      echo "$(tput setaf 1)can't update new configuration"
      echo "check the configuration file /configurations/config.yaml"
      exit 1
    fi
    rm -f temp.txt

  #newly added block

    echo "-----------------------------------------------------------------------------------------------------------------------"
    
    echo "generating certificates for orderer"
    echo "------------------------------------"
    chmod +x ./Orderer_msp/*
    cd ./Orderer_msp
    ./Orderer_msp.sh
    cd ..

    echo "Orderer initialized successfully"


    echo "-----------------------------------------------------------------------------------------------------------------------"

  #end of new block


    echo "$(tput setaf 1)Important Note:$(tput setaf 3)"
    echo "please check all pods are running by 'kubectl get pods --all-namespaces' before adding worker nodes into the cluster..."
    echo "If any pods are remaining in container creating state or pending state, plese wait few seconds"
    echo "you can add any number of worker nodes when these pods all are in running state"
    echo "======================================================================================================================="

  else

    echo "pod network deploying failed exiting"
    exit 1
  fi



end=`date +"%T"`
end_nano=`date +"%N"`
nano_diff=`expr $end_nano - $begin_nano`
nano_diff=${nano_diff#-}
milli_seconds=`expr $nano_diff / 1000000`
begin_seconds=`date -d "$begin" +%s`
end_seconds=`date -d "$end" +%s`
execution_seconds=`expr $end_seconds - $begin_seconds`
echo "execution time: $execution_seconds.$milli_seconds Seconds"

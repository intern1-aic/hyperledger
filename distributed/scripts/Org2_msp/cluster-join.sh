#this script is used to join worker nodes into an existing kuberntes cluster
#we can run this script on any worker nodes to join the cluster
#assuming there is a file named 'join-token.txt' in /nfs/ folder
#the 'join-token.txt' file is automatically saved on /nfs/ folder during creating cluster in master node
begin=`date +"%T"`
begin_nano=`date +"%N"`

echo "kuberntes join"

echo ""

sudo swapoff -a

echo "y" | sudo kubeadm reset >temp.txt

if [ $? -eq 0 ]; then

      echo "[reset] WARNING: Changes made to this host by 'kubeadm init' or 'kubeadm join' will be reverted."
      echo "[preflight] Running pre-flight checks"
      echo "[reset] Stopping the kubelet service"
      echo "[reset] Unmounting mounted directories in '/var/lib/kubelet'"
      echo "[reset] Deleting contents of config directories: [/etc/kubernetes/manifests /etc/kubernetes/pki]"
      echo "[reset] Deleting files: [/etc/kubernetes/admin.conf /etc/kubernetes/kubelet.conf /etc/kubernetes/bootstrap-kubelet.conf /etc/kubernetes/controller-manager.conf /etc/kubernetes/scheduler.conf]"
      echo "[reset] Deleting contents of stateful directories: [/var/lib/kubelet /var/lib/dockershim /var/run/kubernetes /var/lib/cni]"

      sudo rm -R /etc/cni/net.d/*
      if [ $? -eq 0 ]; then
        echo "contents of /etc/cni/net.d/ removed successfully..."

      else
        echo "cannot find /etc/cni/net.d/*"
      fi

      rm -R $HOME/.kube
      if [ $? -eq 0 ]; then
        echo "$HOME/.kube removed successfully"
      else
          echo "cannot find ./kube directory "
      fi
          rm -f ./temp.txt
    
  else
    echo " $(tput setaf 1)existing kubernetes cluster not found.. $(tput setaf 6)"

fi

join=$(</repo/join-token.txt)

sudo $join

rm -f join


end=`date +"%T"`
end_nano=`date +"%N"`
nano_diff=`expr $end_nano - $begin_nano`
nano_diff=${nano_diff#-}
milli_seconds=`expr $nano_diff / 1000000`
begin_seconds=`date -d "$begin" +%s`
end_seconds=`date -d "$end" +%s`
execution_seconds=`expr $end_seconds - $begin_seconds`
echo "execution time: $execution_seconds.$milli_seconds Seconds"
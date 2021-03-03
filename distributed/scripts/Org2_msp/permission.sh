#this script is used to give permissions on worker nodes
#each worker node having its own organization and the appropriate pods are running in those nodes
#we have to set permissions for those pods 


sudo chown -R $USER: /MSP_Org2/
sudo chmod -R a+rwx /MSP_Org2/
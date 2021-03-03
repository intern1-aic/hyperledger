#this script is used to deploy pods into kubernetes cluster
begin=`date +"%T"`
begin_nano=`date +"%N"`

echo "---------------------------------------------------------------------"
echo "--------deploying containeres into kubernetes cluster----------------"
echo "---------------------------------------------------------------------"




 		kubectl apply -f ../orderer/orderer-deploy.yaml
 		kubectl apply -f ../orderer/orderer-svc.yaml

 		kubectl apply -f ../orderer/orderer2-deploy.yaml
 		kubectl apply -f ../orderer/orderer2-svc.yaml

 		kubectl apply -f ../orderer/orderer3-deploy.yaml
 		kubectl apply -f ../orderer/orderer3-svc.yaml

 		kubectl apply -f ../orderer/orderer4-deploy.yaml
 		kubectl apply -f ../orderer/orderer4-svc.yaml

 		kubectl apply -f ../orderer/orderer5-deploy.yaml
 		kubectl apply -f ../orderer/orderer5-svc.yaml




kubectl apply -f ../Org1/org1-peer0-cli.yaml
kubectl apply -f ../Org1/org1-peer0-deploy.yaml
kubectl apply -f ../Org1/org1-peer0-svc.yaml

kubectl apply -f ../Org1/org1-peer1-cli.yaml
kubectl apply -f ../Org1/org1-peer1-deploy.yaml
kubectl apply -f ../Org1/org1-peer1-svc.yaml

kubectl apply -f ../Org1/org1-peer2-cli.yaml
kubectl apply -f ../Org1/org1-peer2-deploy.yaml
kubectl apply -f ../Org1/org1-peer2-svc.yaml

kubectl apply -f ../Org2/org2-peer0-cli.yaml
kubectl apply -f ../Org2/org2-peer0-deploy.yaml
kubectl apply -f ../Org2/org2-peer0-svc.yaml

kubectl apply -f ../Org2/org2-peer1-cli.yaml
kubectl apply -f ../Org2/org2-peer1-deploy.yaml
kubectl apply -f ../Org2/org2-peer1-svc.yaml

kubectl apply -f ../Org2/org2-peer2-cli.yaml
kubectl apply -f ../Org2/org2-peer2-deploy.yaml
kubectl apply -f ../Org2/org2-peer2-svc.yaml


kubectl apply -f ../Org3/org3-peer0-cli.yaml
kubectl apply -f ../Org3/org3-peer0-deploy.yaml
kubectl apply -f ../Org3/org3-peer0-svc.yaml

kubectl apply -f ../Org3/org3-peer1-cli.yaml
kubectl apply -f ../Org3/org3-peer1-deploy.yaml
kubectl apply -f ../Org3/org3-peer1-svc.yaml

kubectl apply -f ../Org3/org3-peer2-cli.yaml
kubectl apply -f ../Org3/org3-peer2-deploy.yaml
kubectl apply -f ../Org3/org3-peer2-svc.yaml
#Pods
 


sudo chmod -R a+rwx /repo
sudo chmod -R 777 /repo

end=`date +"%T"`
end_nano=`date +"%N"`
nano_diff=`expr $end_nano - $begin_nano`
nano_diff=${nano_diff#-}
milli_seconds=`expr $nano_diff / 1000000`
begin_seconds=`date -d "$begin" +%s`
end_seconds=`date -d "$end" +%s`
execution_seconds=`expr $end_seconds - $begin_seconds`
echo "execution time: $execution_seconds.$milli_seconds Seconds"
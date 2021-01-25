#this script is used to deploy pods into kubernetes cluster
begin=`date +"%T"`
begin_nano=`date +"%N"`

echo "---------------------------------------------------------------------"
echo "--------deploying containeres into kubernetes cluster----------------"
echo "---------------------------------------------------------------------"

sudo chmod -R a+rwx /repo
sudo chmod -R 777 /repo

cp ./configtx.yaml /repo/config

export FABRIC_CFG_PATH=/repo/config

./bin/configtxgen -profile SampleMultiNodeEtcdRaft -channelID byfn-sys-channel -outputBlock ./channel-artifacts/genesis.block

 export CHANNEL_NAME=aichannel  && ./bin/configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID $CHANNEL_NAME

./bin/configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID "aichannel" -asOrg Org1MSP
./bin/configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchors.tx -channelID "aichannel" -asOrg Org2MSP
./bin/configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org3MSPanchors.tx -channelID "aichannel" -asOrg Org3MSP

cp -r ./channel-artifacts/* /repo/config
rm -rf ./channel-artifacts
rm -rf /repo/config/configtx.yaml
 
 sleep 5s
kubectl apply -f ../volumes/fabric-pv.yaml

if [ $? -eq 0 ]; then

	kubectl apply -f ../volumes/fabric-pvc.yaml 

	if [ $? -eq 0 ]; then

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
kubectl apply -f ../Org2/org2-peer0-cli.yaml
kubectl apply -f ../Org2/org2-peer0-deploy.yaml
kubectl apply -f ../Org2/org2-peer0-svc.yaml
kubectl apply -f ../Org3/org3-peer0-cli.yaml
kubectl apply -f ../Org3/org3-peer0-deploy.yaml
kubectl apply -f ../Org3/org3-peer0-svc.yaml
#Pods
 	fi
 fi


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
#this script is used to deploy pods into kubernetes cluster

begin=`date +"%T"`
begin_nano=`date +"%N"`

echo "---------------------------------------------------------------------"
echo "--------Creating required files for channel creation-----------------"
echo "---------------------------------------------------------------------"


export FABRIC_CFG_PATH=${PWD}
#generates orderer msp's
./bin/cryptogen generate --config=./crypto-config.yaml

mkdir ./crypto-config/peerOrganizations

kubectl get pods > ch1.txt
awk '{ print $1 }' ch1.txt > ch2.txt
Org1=$(grep 'org1' ch2.txt )
Org2=$(grep 'org2' ch2.txt )
Org3=$(grep 'org3' ch2.txt )


kubectl cp $Org1:/MSP_Org1/config/crypto-config/peerOrganizations/ ./crypto-config/peerOrganizations
kubectl cp $Org2:/MSP_Org2/config/crypto-config/peerOrganizations/ ./crypto-config/peerOrganizations
kubectl cp $Org3:/MSP_Org3/config/crypto-config/peerOrganizations/ ./crypto-config/peerOrganizations
	

./bin/configtxgen -profile SampleMultiNodeEtcdRaft -channelID byfn-sys-channel -outputBlock ./channel-artifacts/genesis.block


export CHANNEL_NAME=channel4  && ./bin/configtxgen -profile ThreeOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel4.tx -channelID $CHANNEL_NAME
export CHANNEL_NAME=channel1  && ./bin/configtxgen -profile InnerOrgsChannel1 -outputCreateChannelTx ./channel-artifacts/channel1.tx -channelID $CHANNEL_NAME
export CHANNEL_NAME=channel2  && ./bin/configtxgen -profile InnerOrgsChannel2 -outputCreateChannelTx ./channel-artifacts/channel2.tx -channelID $CHANNEL_NAME
export CHANNEL_NAME=channel3  && ./bin/configtxgen -profile InnerOrgsChannel3 -outputCreateChannelTx ./channel-artifacts/channel3.tx -channelID $CHANNEL_NAME

./bin/configtxgen -profile InnerOrgsChannel1 -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID "channel1" -asOrg Org1MSP
./bin/configtxgen -profile InnerOrgsChannel2 -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchors.tx -channelID "channel2" -asOrg Org2MSP
./bin/configtxgen -profile InnerOrgsChannel3 -outputAnchorPeersUpdate ./channel-artifacts/Org3MSPanchors.tx -channelID "channel3" -asOrg Org3MSP

kubectl cp ./channel-artifacts/channel1.tx default/$Org1:/MSP_Org1/config
kubectl cp ./channel-artifacts/channel2.tx default/$Org2:/MSP_Org2/config
kubectl cp ./channel-artifacts/channel3.tx default/$Org3:/MSP_Org3/config
kubectl cp ./channel-artifacts/channel4.tx default/$Org1:/MSP_Org1/config
kubectl cp ./channel-artifacts/genesis.block default/$Org1:/MSP_Org1/config
kubectl cp ./channel-artifacts/genesis.block default/$Org2:/MSP_Org2/config
kubectl cp ./channel-artifacts/genesis.block default/$Org3:/MSP_Org3/config

kubectl cp ./channel-artifacts/Org1MSPanchors.tx default/$Org1:/MSP_Org1/config
kubectl cp ./channel-artifacts/Org2MSPanchors.tx default/$Org2:/MSP_Org2/config
kubectl cp ./channel-artifacts/Org3MSPanchors.tx default/$Org3:/MSP_Org3/config

kubectl cp ./crypto-config/ordererOrganizations/ default/$Org1:/MSP_Org1/config/crypto-config
kubectl cp ./crypto-config/ordererOrganizations/ default/$Org2:/MSP_Org2/config/crypto-config
kubectl cp ./crypto-config/ordererOrganizations/ default/$Org3:/MSP_Org3/config/crypto-config



#rm -rf ./channel-artifacts
#rm -rf ./crypto-config
rm ch1.txt ch2.txt


end=`date +"%T"`
end_nano=`date +"%N"`
nano_diff=`expr $end_nano - $begin_nano`
nano_diff=${nano_diff#-}
milli_seconds=`expr $nano_diff / 1000000`
begin_seconds=`date -d "$begin" +%s`
end_seconds=`date -d "$end" +%s`
execution_seconds=`expr $end_seconds - $begin_seconds`
echo "execution time: $execution_seconds.$milli_seconds Seconds"

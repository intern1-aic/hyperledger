#this script is used to deploy pods into kubernetes cluster
begin=`date +"%T"`
begin_nano=`date +"%N"`

echo "---------------------------------------------------------------------"
echo "--------Creating required files for channel creation-----------------"
echo "---------------------------------------------------------------------"

sudo chmod -R a+rwx /repo
sudo chmod -R 777 /repo

cp ./configtx.yaml /repo/config

export FABRIC_CFG_PATH=/repo/config

./bin/configtxgen -profile SampleMultiNodeEtcdRaft -channelID byfn-sys-channel -outputBlock ./channel-artifacts/genesis.block

export CHANNEL_NAME=channel1  && ./bin/configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel1.tx -channelID $CHANNEL_NAME
export CHANNEL_NAME=channel2  && ./bin/configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel2.tx -channelID $CHANNEL_NAME
export CHANNEL_NAME=channel3  && ./bin/configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel3.tx -channelID $CHANNEL_NAME
export CHANNEL_NAME=channel4  && ./bin/configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel4.tx -channelID $CHANNEL_NAME

./bin/configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID "channel1" -asOrg Org1MSP
./bin/configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchors.tx -channelID "channel2" -asOrg Org2MSP
./bin/configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org3MSPanchors.tx -channelID "channel3" -asOrg Org3MSP


cp -r ./channel-artifacts/* /repo/config
rm -rf ./channel-artifacts
rm -rf /repo/config/configtx.yaml
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
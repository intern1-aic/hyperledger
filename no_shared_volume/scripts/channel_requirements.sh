#this script is used to deploy pods into kubernetes cluster
# parse_yaml() {
#    local prefix=$2
#    local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
#    sed -ne "s|^\($s\)\($w\)$s:$s\"\(.*\)\"$s\$|\1$fs\2$fs\3|p" \
#         -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
#    awk -F$fs '{
#       indent = length($1)/2;
#       vname[indent] = $2;
#       for (i in vname) {if (i > indent) {delete vname[i]}}
#       if (length($3) > 0) {
#          vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
#          printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
#       }
#    }'
# }


begin=`date +"%T"`
begin_nano=`date +"%N"`

# eval $(parse_yaml ../config/config.yaml "config_")

# UserName1=$config_Org1_username
# NodeIP1=$config_Org1_ip
# UserName2=$config_Org2_username
# NodeIP2=$config_Org2_ip
# UserName3=$config_Org2_username
# NodeIP3=$config_Org2_ip


# pattern="^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"

echo "---------------------------------------------------------------------"
echo "--------Creating required files for channel creation-----------------"
echo "---------------------------------------------------------------------"



		# if [[ ( $NodeIP1 =~ $pattern ) || ( $NodeIP2 =~ $pattern )  || ( $NodeIP3 =~ $pattern ) ]]; then
		# 	echo "Org1 node IP:" $NodeIP1
		# 	echo "Org1 node UserName:" $UserName1
		# 	echo "Org2 node IP:" $NodeIP2
		# 	echo "Org2 node UserName:" $UserName2
		# 	echo "Org3 node IP:" $NodeIP3
		# 	echo "Org3 node UserName:" $UserName3

		# 	scp -r $UserName1@$NodeIP1:/MSP_Org1/config/crypto-config/peerOrganizations/* /repo/config/crypto-config/peerOrganizations > temp.txt
		# 	scp -r /repo/config/crt/ $UserName1@$NodeIP1:/MSP_Org1/config/ > temp2.txt
		# 	rm temp.txt temp2.txt

		# 	scp -r $UserName1@$NodeIP2:/MSP_Org2/config/crypto-config/peerOrganizations/* /repo/config/crypto-config/peerOrganizations > temp.txt
		# 	scp -r /repo/config/crt/ $UserName2@$NodeIP2:/MSP_Org2/config/ > temp2.txt
		# 	rm temp.txt temp2.txt	

		# 	scp -r $UserName3@$NodeIP3:/MSP_Org3/config/crypto-config/peerOrganizations/* /repo/config/crypto-config/peerOrganizations > temp.txt
		# 	scp -r /repo/config/crt/ $UserName3@$NodeIP3:/MSP_Org3/config/ > temp2.txt
		# 	rm temp.txt temp2.txt			
		# else
		# 		echo " some ip address is not valid. check the ip address in config file.."
		# 		exit 1
		# fi		
	
	


sudo chmod -R a+rwx /repo
sudo chmod -R 777 /repo

cp ./configtx.yaml /repo/config


export FABRIC_CFG_PATH=/repo/config

./bin/configtxgen -profile SampleMultiNodeEtcdRaft -channelID byfn-sys-channel -outputBlock ./channel-artifacts/genesis.block


export CHANNEL_NAME=channel4  && ./bin/configtxgen -profile ThreeOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel4.tx -channelID $CHANNEL_NAME



export CHANNEL_NAME=channel1  && ./bin/configtxgen -profile InnerOrgsChannel1 -outputCreateChannelTx ./channel-artifacts/channel1.tx -channelID $CHANNEL_NAME
export CHANNEL_NAME=channel2  && ./bin/configtxgen -profile InnerOrgsChannel2 -outputCreateChannelTx ./channel-artifacts/channel2.tx -channelID $CHANNEL_NAME
export CHANNEL_NAME=channel3  && ./bin/configtxgen -profile InnerOrgsChannel3 -outputCreateChannelTx ./channel-artifacts/channel3.tx -channelID $CHANNEL_NAME

./bin/configtxgen -profile InnerOrgsChannel1 -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID "channel1" -asOrg Org1MSP
./bin/configtxgen -profile InnerOrgsChannel2 -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchors.tx -channelID "channel2" -asOrg Org2MSP
./bin/configtxgen -profile InnerOrgsChannel3 -outputAnchorPeersUpdate ./channel-artifacts/Org3MSPanchors.tx -channelID "channel3" -asOrg Org3MSP


cp -r ./channel-artifacts/* /repo/config
rm -rf ./channel-artifacts
rm -rf /repo/config/configtx.yaml
rm -rf /repo/config/crypto-config/peerOrganizations
#rm -rf /repo/config/crt
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
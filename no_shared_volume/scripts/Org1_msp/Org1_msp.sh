					#this script is used to generate the msp and essential binaries for fabric 2.0

begin=`date +"%T"`
begin_nano=`date +"%N"`
#sudo chmod -R a+rwx /repo


if [ ! -e /MSP_Org1 ]; then
	sudo mkdir /MSP_Org1
	sudo chmod -R a+rwx /MSP_Org1
else
	sudo chmod -R a+rwx /MSP_Org1
fi

 if [ -e ./crypto-config ]; then

         rm -r ./crypto-config
 fi

sudo rm -rf /MSP_Org1/*
mkdir -p /MSP_Org1/config/crypto-config/peerOrganizations
/repo/config/bin/cryptogen generate --config=./crypto-config.yaml
mv ./crypto-config/peerOrganizations/aic.ai.com/ /MSP_Org1/config/crypto-config/peerOrganizations/aic.ai.com
cp -r /MSP_Org1/config/crypto-config/peerOrganizations/aic.ai.com/ /repo/config/crypto-config/peerOrganizations
cp /repo/config/crypto-config/peerOrganizations/aic.ai.com/peers/peer0.aic.ai.com/tls/server.crt /repo/config/crt/org1/

file=0
file2=0
T=0

while [[ $T -eq 0 ]]; do
	if [ ! -e /repo/config/channel1.tx ]; then
	echo -ne "please execute channel_requirements.sh in master node to generate essential binaries..channel1.tx file is missing...\r"
	#sleep 3s
else
	echo "channel1.tx file is found at /repo/config"
	file=1
	if [[ ! -e /repo/config/channel4.tx ]]; then
		echo -ne "please execute channel_requirements.sh in master node to generate essential binaries..channel1.tx file is missing...\r"
	else
		file2=1
		echo "channel4.tx file is found at /repo/config"
		T=1
		break
	fi
fi
done

if [[ $file -eq 1 && $file2 -eq 1 ]]; then
	
	cp -r /repo/config/crypto-config/ordererOrganizations/ /MSP_Org1/config/crypto-config
	mv /repo/config/channel1.tx /MSP_Org1/config/channel1.tx
	cp /repo/config/channel4.tx /MSP_Org1/config
	mv /repo/config/Org1MSPanchors.tx  /MSP_Org1/config/Org1MSPanchors.tx
	
fi


cp -r /repo/config/crt /MSP_Org1/config/
cp -r /repo/config/Org1_msp /MSP_Org1/config/
cp -r /repo/config/chaincode /MSP_Org1/config/
rm -rf ./crypto-config

echo "files generated successfully.."

echo "copied to /MSP_Org1/config"

end=`date +"%T"`
end_nano=`date +"%N"`
nano_diff=`expr $end_nano - $begin_nano`
nano_diff=${nano_diff#-}
milli_seconds=`expr $nano_diff / 1000000`
begin_seconds=`date -d "$begin" +%s`
end_seconds=`date -d "$end" +%s`
execution_seconds=`expr $end_seconds - $begin_seconds`
echo "execution time: $execution_seconds.$milli_seconds Seconds"
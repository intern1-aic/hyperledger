#this script is used to generate the msp and essential binaries for fabric 2.0

begin=`date +"%T"`
begin_nano=`date +"%N"`
#sudo chmod -R a+rwx /repo

if [ ! -e /MSP_Org2 ]; then
	sudo mkdir /MSP_Org2
	sudo chmod -R a+rwx /MSP_Org2
else
	sudo chmod -R a+rwx /MSP_Org2
fi

 if [ -e ./crypto-config ]; then

         rm -r ./crypto-config
 fi

sudo rm -rf /MSP_Org2/*
mkdir -p /MSP_Org2/config/crypto-config/peerOrganizations
/repo/config/bin/cryptogen generate --config=./crypto-config.yaml
mv ./crypto-config/peerOrganizations/bel.ai.com/ /MSP_Org2/config/crypto-config/peerOrganizations/bel.ai.com
# cp -r /MSP_Org2/config/crypto-config/peerOrganizations/bel.ai.com/ /repo/config/crypto-config/peerOrganizations
# cp /MSP_Org2/config/crypto-config/peerOrganizations/bel.ai.com/peers/peer0.bel.ai.com/tls/server.crt /repo/config/crt
# mv /repo/config/crt/server.crt /repo/config/crt/server2.crt

cp -r /MSP_Org2/config/crypto-config/peerOrganizations/bel.ai.com/ /repo/config/crypto-config/peerOrganizations
cp /repo/config/crypto-config/peerOrganizations/bel.ai.com/peers/peer0.bel.ai.com/tls/server.crt /repo/config/crt/org2/

file=0
file2=0
T=0

while [[ $T -eq 0 ]]; do
	if [ ! -e /repo/config/channel2.tx ]; then
	echo -ne "please execute channel_requirements.sh in master node to generate essential binaries..channel2.tx file is missing...\r"
	#sleep 3s
else
	echo "channel2.tx file is found at /repo/config"
	file=1
	if [[ ! -e /repo/config/channel4.tx ]]; then
		echo -ne "please execute channel_requirements.sh in master node to generate essential binaries..channel4.tx file is missing...\r"
	else
		file2=1
		echo "channel4.tx file is found at /repo/config"
		T=1
		break
	fi
fi
done

if [[ $file -eq 1 && $file2 -eq 1 ]]; then
	
	cp -r /repo/config/crypto-config/ordererOrganizations/ /MSP_Org2/config/crypto-config
	mv /repo/config/channel2.tx /MSP_Org2/config/channel2.tx
	cp /repo/config/channel4.tx /MSP_Org2/config
	mv /repo/config/Org2MSPanchors.tx  /MSP_Org2/config/Org2MSPanchors.tx
	cp -r /repo/config/chaincode /MSP_Org2/config/
fi

cp -r /repo/config/crt /MSP_Org2/config/
cp -r /repo/config/Org2_msp /MSP_Org2/config
cp -r /repo/config/chaincode /MSP_Org2/config/
rm -rf ./crypto-config

echo "files generated successfully.."

echo "copied to /MSP_Org2/config"

end=`date +"%T"`
end_nano=`date +"%N"`
nano_diff=`expr $end_nano - $begin_nano`
nano_diff=${nano_diff#-}
milli_seconds=`expr $nano_diff / 1000000`
begin_seconds=`date -d "$begin" +%s`
end_seconds=`date -d "$end" +%s`
execution_seconds=`expr $end_seconds - $begin_seconds`
echo "execution time: $execution_seconds.$milli_seconds Seconds"
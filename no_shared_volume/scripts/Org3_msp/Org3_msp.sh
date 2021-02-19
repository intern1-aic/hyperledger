#this script is used to generate the msp and essential binaries for fabric 2.0

begin=`date +"%T"`
begin_nano=`date +"%N"`
#sudo chmod -R a+rwx /repo


if [ ! -e /MSP_Org3 ]; then
	sudo mkdir /MSP_Org3
	sudo chmod -R a+rwx /MSP_Org3
else
	sudo chmod -R a+rwx /MSP_Org3
fi

 if [ -e ./crypto-config ]; then

         rm -r ./crypto-config
 fi




sudo rm -rf /MSP_Org3/*
mkdir -p /MSP_Org3/config/crypto-config/peerOrganizations
/repo/config/bin/cryptogen generate --config=./crypto-config.yaml
mv ./crypto-config/peerOrganizations/iiit.ai.com/ /MSP_Org3/config/crypto-config/peerOrganizations/iiit.ai.com
# cp -r /MSP_Org3/config/crypto-config/peerOrganizations/iiit.ai.com/ /repo/config/crypto-config/peerOrganizations
# cp /MSP_Org3/config/crypto-config/peerOrganizations/iiit.ai.com/peers/peer0.iiit.ai.com/tls/server.crt /repo/config/crt
# mv /repo/config/crt/server.crt /repo/config/crt/server3.crt


cp -r /MSP_Org3/config/crypto-config/peerOrganizations/iiit.ai.com/ /repo/config/crypto-config/peerOrganizations
cp /repo/config/crypto-config/peerOrganizations/iiit.ai.com/peers/peer0.iiit.ai.com/tls/server.crt /repo/config/crt/org3/


file=0
file2=0
T=0

while [[ $T -eq 0 ]]; do
	if [ ! -e /repo/config/channel3.tx ]; then
	echo -ne "please execute channel_requirements.sh in master node to generate essential binaries..channel3.tx file is missing...\r"
	#sleep 3s
else
	echo "channel3.tx file is found at /repo/config"
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
	
	cp -r /repo/config/crypto-config/ordererOrganizations/ /MSP_Org3/config/crypto-config
	mv /repo/config/channel3.tx /MSP_Org3/config/channel3.tx
	cp /repo/config/channel4.tx /MSP_Org3/config
	mv /repo/config/Org3MSPanchors.tx  /MSP_Org3/config/Org3MSPanchors.tx
	cp -r /repo/config/chaincode /MSP_Org3/config/
fi

cp -r /repo/config/crt /MSP_Org3/config/
cp -r /repo/config/Org3_msp /MSP_Org3/config
cp -r /repo/config/chaincode /MSP_Org3/config/
rm -rf ./crypto-config
echo "files generated successfully.."

echo "copied to /MSP_Org3/config"

end=`date +"%T"`
end_nano=`date +"%N"`
nano_diff=`expr $end_nano - $begin_nano`
nano_diff=${nano_diff#-}
milli_seconds=`expr $nano_diff / 1000000`
begin_seconds=`date -d "$begin" +%s`
end_seconds=`date -d "$end" +%s`
execution_seconds=`expr $end_seconds - $begin_seconds`
echo "execution time: $execution_seconds.$milli_seconds Seconds"
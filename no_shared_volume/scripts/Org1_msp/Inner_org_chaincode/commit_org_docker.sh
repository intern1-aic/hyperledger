#this script is used to commit the chaincode in all peers..it should be run in only one peer

begin=`date +"%T"`
OrgName="cli-aic"
CHANNEL_NAME=channel1
CHAINCODE_NAME=fabcar_1

docker ps >> temp.txt
grep "k8s_cli_cli-aic-peer0" temp.txt >> temp2.txt
awk '{ print $1 }' temp2.txt > temp3.txt
rm -f temp.txt temp2.txt

cli=$(head -n 1 temp3.txt)


S=0
c=1
	while [[ $S -eq 0 ]]; do

		docker  exec $cli /bin/sh -c "peer lifecycle chaincode commit -o orderer.ai.com:7050 --tls true --cafile /MSP_Org1/config/crypto-config/ordererOrganizations/ai.com/orderers/orderer.ai.com/msp/tlscacerts/tlsca.ai.com-cert.pem --channelID channel1 --name fabcar_1 --peerAddresses peer0.aic.ai.com:7051 --tlsRootCertFiles /MSP_Org1/config/crypto-config/peerOrganizations/aic.ai.com/peers/peer0.aic.ai.com/tls/server.crt --version 1 --sequence 1 --init-required"
		docker  exec $cli /bin/sh -c "peer lifecycle chaincode querycommitted --channelID channel1 --name fabcar_1"
		

	if [[ $? -eq 0 ]]; then
		s=1
		break
				
	else
		echo "an error occured..retrying.."
		sleep 4s
	fi
	done
	
rm temp3.txt

end=`date +"%T"`
temp1=`date -d "$begin" +%s`
temp2=`date -d "$end" +%s`
sla=`expr $temp2 - $temp1`
echo "execution time: $sla Seconds"
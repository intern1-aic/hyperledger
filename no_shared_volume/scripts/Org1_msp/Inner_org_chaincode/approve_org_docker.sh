#this script is used to approve the chaincode in all peers 

begin=`date +"%T"`
OrgName="cli-aic"
CHANNEL_NAME=channel1
CHAINCODE_NAME=fabcar_1

docker ps >> temp.txt
grep "k8s_cli_cli-aic-peer0" temp.txt >> temp2.txt
awk '{ print $1 }' temp2.txt > temp3.txt
rm -f temp.txt temp2.txt

cli=$(head -n 1 temp3.txt)

docker  exec $cli /bin/sh -c "peer lifecycle chaincode queryinstalled " > log.txt
grep "fabcar_1" log.txt > log1.txt
PACKAGE_ID=`sed -n '/Package/{s/^Package ID: //; s/, Label:.*$//; p;}' log1.txt`
rm log1.txt log.txt

S=0
c=1
	while [[ $S -eq 0 ]]; do

		docker  exec $cli /bin/sh -c "peer lifecycle chaincode approveformyorg --tls --cafile /MSP_Org1/config/crypto-config/ordererOrganizations/ai.com/orderers/orderer.ai.com/msp/tlscacerts/tlsca.ai.com-cert.pem --channelID channel1 --name fabcar_1 --version 1 --init-required --package-id $PACKAGE_ID --sequence 1 --waitForEvent"
		docker  exec $cli /bin/sh -c "peer lifecycle chaincode checkcommitreadiness --channelID channel1 --name fabcar_1 --version 1 --sequence 1 --output json --init-required " >> approve.txt
		
		grep '"Org1MSP": true' approve.txt

	if [[ $? -eq 0 ]]; then
		s=1		
		rm -f approve.txt
		break	
		
	else
		echo "an error occured..retrying.."
		sleep 4s
	fi
	done
	
	rm -f approve.txt

rm temp3.txt

end=`date +"%T"`
temp1=`date -d "$begin" +%s`
temp2=`date -d "$end" +%s`
sla=`expr $temp2 - $temp1`
echo "execution time: $sla Seconds"
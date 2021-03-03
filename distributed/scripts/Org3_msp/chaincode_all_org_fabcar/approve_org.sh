#this script is used to approve the chaincode in all peers 

begin=`date +"%T"`
OrgName="cli-iiit"
CHANNEL_NAME=iiithannel4
CHAINCODE_NAME=fabcar_go-all

kubectl get pods >> temp.txt
grep "cli-iiit" temp.txt >> temp2.txt
awk '{ print $1 }' temp2.txt > temp3.txt
rm -f temp.txt temp2.txt

cli=$(head -n 1 temp3.txt)

kubectl exec $cli -- sh -c "peer lifecycle chaincode queryinstalled " > log1.txt
grep "fabcar_go-all" log1.txt > log2.txt
PACKAGE_ID=`sed -n '/Package/{s/^Package ID: //; s/, Label:.*$//; p;}' log2.txt`
rm -f log1.txt log2.txt

S=0
c=1
	while [[ $S -eq 0 ]]; do

		kubectl exec $cli -- sh -c "peer lifecycle chaincode approveformyorg --tls --cafile /MSP_Org3/config/crypto-config/ordererOrganizations/ai.com/orderers/orderer4.ai.com/msp/tlscacerts/tlsca.ai.com-cert.pem --channelID channel4 --name fabcar_go-all --version 1 --init-required --package-id $PACKAGE_ID --sequence 1 --waitForEvent"
		kubectl exec $cli -- sh -c "peer lifecycle chaincode checkcommitreadiness --channelID channel4 --name fabcar_go-all --version 1 --sequence 1 --output json --init-required " >> approve.txt
		
		grep '"Org3MSP": true' approve.txt

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
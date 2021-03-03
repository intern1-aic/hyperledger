#this script is used to commit the chaincode in all peers..it should be run in only one peer

begin=`date +"%T"`
OrgName="cli-bel"
CHANNEL_NAME=channel4
CHAINCODE_NAME=fabcar_go-all

kubectl get pods >> temp.txt
grep "cli-bel" temp.txt >> temp2.txt
awk '{ print $1 }' temp2.txt > temp3.txt
rm -f temp.txt temp2.txt

cli=$(head -n 1 temp3.txt)


S=0
c=1
	while [[ $S -eq 0 ]]; do

		kubectl exec $cli -- sh -c "peer lifecycle chaincode commit -o orderer4.ai.com:10050 --tls true --cafile /MSP_Org2/config/crypto-config/ordererOrganizations/ai.com/orderers/orderer.ai.com/msp/tlscacerts/tlsca.ai.com-cert.pem --channelID channel4 --name fabcar_go-all --peerAddresses peer0.aic.ai.com:7051 --tlsRootCertFiles /MSP_Org2/config/crt/org1/server.crt --peerAddresses peer0.bel.ai.com:7051 --tlsRootCertFiles /MSP_Org2/config/crt/org2/server.crt --peerAddresses peer0.iiit.ai.com:7051 --tlsRootCertFiles /MSP_Org2/config/crt/org3/server.crt --version 1 --sequence 1 --init-required"
		kubectl exec $cli -- sh -c "peer lifecycle chaincode querycommitted --channelID channel4 --name fabcar_go-all"
		

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
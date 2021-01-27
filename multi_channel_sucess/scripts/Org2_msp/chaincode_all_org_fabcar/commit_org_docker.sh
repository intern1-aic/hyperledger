#this script is used to commit the chaincode in all peers..it should be run in only one peer

begin=`date +"%T"`
OrgName="cli-bel"
CHANNEL_NAME=channel4
CHAINCODE_NAME=fabcar_go-all

docker ps >> temp.txt
grep "k8s_cli_cli-bel-peer0" temp.txt >> temp2.txt
awk '{ print $1 }' temp2.txt > temp3.txt
rm -f temp.txt temp2.txt

cli=$(head -n 1 temp3.txt)


S=0
c=1
	while [[ $S -eq 0 ]]; do

		docker  exec $cli /bin/sh -c "peer lifecycle chaincode commit -o orderer4.ai.com:10050 --tls true --cafile /repo/config/crypto-config/ordererOrganizations/ai.com/orderers/orderer.ai.com/msp/tlscacerts/tlsca.ai.com-cert.pem --channelID channel4 --name fabcar_go-all --peerAddresses peer0.aic.ai.com:7051 --tlsRootCertFiles /repo/config/crypto-config/peerOrganizations/aic.ai.com/peers/peer0.aic.ai.com/tls/server.crt --peerAddresses peer0.bel.ai.com:7051 --tlsRootCertFiles /repo/config/crypto-config/peerOrganizations/bel.ai.com/peers/peer0.bel.ai.com/tls/server.crt --peerAddresses peer0.iiit.ai.com:7051 --tlsRootCertFiles /repo/config/crypto-config/peerOrganizations/iiit.ai.com/peers/peer0.iiit.ai.com/tls/server.crt --version 1 --sequence 1 --init-required"
		docker  exec $cli /bin/sh -c "peer lifecycle chaincode querycommitted --channelID channel4 --name fabcar_go-all"
		

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
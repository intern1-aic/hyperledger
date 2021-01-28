#this script is used to initialize the chaincode

begin=`date +"%T"`
OrgName="cli-iiit"
CHANNEL_NAME=channel3
CHAINCODE_NAME=fabcar_3

kubectl get pods >> temp.txt
grep "cli-iiit" temp.txt >> temp2.txt
awk '{ print $1 }' temp2.txt > temp3.txt
rm -f temp.txt temp2.txt

cli=$(head -n 1 temp3.txt)

br='"'
sb="'"
args=$sb'{'$br'function'$br':'$br'initLedger'$br','$br'Args'$br':[]}'$sb

S=0
c=1
	while [[ $S -eq 0 ]]; do

		kubectl exec $cli -- sh -c "peer chaincode invoke -o orderer3.ai.com:9050 --tls true --cafile /repo/config/crypto-config/ordererOrganizations/ai.com/orderers/orderer3.ai.com/msp/tlscacerts/tlsca.ai.com-cert.pem -C channel3 -n fabcar_3 --peerAddresses peer0.iiit.ai.com:7051 --tlsRootCertFiles /repo/config/crypto-config/peerOrganizations/iiit.ai.com/peers/peer0.iiit.ai.com/tls/server.crt --isInit -c $args"


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
#this script is used to initialize the chaincode

begin=`date +"%T"`
OrgName="cli-aic"
CHANNEL_NAME=channel4
CHAINCODE_NAME=fabcar_go-all

docker ps >> temp.txt
grep "k8s_cli_cli-aic-peer0" temp.txt >> temp2.txt
awk '{ print $1 }' temp2.txt > temp3.txt
rm -f temp.txt temp2.txt

cli=$(head -n 1 temp3.txt)

br='"'
sb="'"
args=$sb'{'$br'function'$br':'$br'initLedger'$br','$br'Args'$br':[]}'$sb

S=0
c=1
	while [[ $S -eq 0 ]]; do

		docker  exec $cli /bin/sh -c "peer chaincode invoke -o orderer4.ai.com:10050 --tls true --cafile /MSP_Org1/config/crypto-config/ordererOrganizations/ai.com/orderers/orderer4.ai.com/msp/tlscacerts/tlsca.ai.com-cert.pem -C channel4 -n fabcar_go-all --peerAddresses peer0.aic.ai.com:7051 --tlsRootCertFiles /MSP_Org1/config/crt/org1/server.crt --peerAddresses peer0.bel.ai.com:7051 --tlsRootCertFiles /MSP_Org1/config/crt/org2/server.crt --peerAddresses peer0.iiit.ai.com:7051 --tlsRootCertFiles /MSP_Org1/config/crt/org3/server.crt --isInit -c $args"


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
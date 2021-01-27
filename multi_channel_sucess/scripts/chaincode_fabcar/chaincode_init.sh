#this script is used to initialize the chaincode

begin=`date +"%T"`


peer chaincode invoke -o orderer.ai.com:7050 --tls true --cafile /repo/config/crypto-config/ordererOrganizations/ai.com/orderers/orderer.ai.com/msp/tlscacerts/tlsca.ai.com-cert.pem -C aichannel1 -n fabcar_go --peerAddresses peer0.aic.ai.com:7051 --tlsRootCertFiles /repo/config/crypto-config/peerOrganizations/aic.ai.com/peers/peer0.aic.ai.com/tls/server.crt --peerAddresses peer0.bel.ai.com:7051 --tlsRootCertFiles /repo/config/crypto-config/peerOrganizations/bel.ai.com/peers/peer0.bel.ai.com/tls/server.crt --peerAddresses peer0.iiit.ai.com:7051 --tlsRootCertFiles /repo/config/crypto-config/peerOrganizations/iiit.ai.com/peers/peer0.iiit.ai.com/tls/server.crt --isInit -c '{"function":"initLedger","Args":[]}'
#Init
end=`date +"%T"`
temp1=`date -d "$begin" +%s`
temp2=`date -d "$end" +%s`
sla=`expr $temp2 - $temp1`
echo "execution time: $sla Seconds"
#this script is used to initialize the chaincode

begin=`date +"%T"`


peer chaincode invoke -o orderer.ai.com:7050 --tls true --cafile /repo/config/crypto-config/ordererOrganizations/ai.com/orderers/orderer.ai.com/msp/tlscacerts/tlsca.ai.com-cert.pem -C aichannel -n fabcar_go --peerAddresses peer0.org1.ai.com:7051 --tlsRootCertFiles /repo/config/crypto-config/peerOrganizations/org1.ai.com/peers/peer0.org1.ai.com/tls/server.crt --peerAddresses peer0.org2.ai.com:7051 --tlsRootCertFiles /repo/config/crypto-config/peerOrganizations/org2.ai.com/peers/peer0.org2.ai.com/tls/server.crt --peerAddresses peer0.org3.ai.com:7051 --tlsRootCertFiles /repo/config/crypto-config/peerOrganizations/org3.ai.com/peers/peer0.org3.ai.com/tls/server.crt --isInit -c '{"function":"initLedger","Args":[]}'
#Init
end=`date +"%T"`
temp1=`date -d "$begin" +%s`
temp2=`date -d "$end" +%s`
sla=`expr $temp2 - $temp1`
echo "execution time: $sla Seconds"
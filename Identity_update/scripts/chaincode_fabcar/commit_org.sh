#this script is used to commit the chaincode in all peers..it should be run in only one peer

begin=`date +"%T"`


#peer lifecycle chaincode commit -o orderer.ai.com:7050 --tls true --cafile /repo/config/crypto-config/ordererOrganizations/ai.com/orderers/orderer.ai.com/msp/tlscacerts/tlsca.ai.com-cert.pem --channelID aichannel --name aichain --peerAddresses peer0.org1.ai.com:7051 --tlsRootCertFiles /repo/config/crypto-config/peerOrganizations/org1.ai.com/peers/peer0.org1.ai.com/tls/server.crt --peerAddresses peer0.org2.ai.com:7051 --tlsRootCertFiles /repo/config/crypto-config/peerOrganizations/org2.ai.com/peers/peer0.org2.ai.com/tls/server.crt --peerAddresses peer0.org3.ai.com:7051 --tlsRootCertFiles /repo/config/crypto-config/peerOrganizations/org3.ai.com/peers/peer0.org3.ai.com/tls/server.crt --version 1 --sequence 1 --init-required

peer lifecycle chaincode commit -o orderer.ai.com:7050 --tls true --cafile /repo/config/crypto-config/ordererOrganizations/ai.com/orderers/orderer.ai.com/msp/tlscacerts/tlsca.ai.com-cert.pem --channelID aichannel --name fabcar_go --peerAddresses peer0.org1.ai.com:7051 --tlsRootCertFiles /repo/config/crypto-config/peerOrganizations/org1.ai.com/peers/peer0.org1.ai.com/tls/server.crt --peerAddresses peer0.org2.ai.com:7051 --tlsRootCertFiles /repo/config/crypto-config/peerOrganizations/org2.ai.com/peers/peer0.org2.ai.com/tls/server.crt --peerAddresses peer0.org3.ai.com:7051 --tlsRootCertFiles /repo/config/crypto-config/peerOrganizations/org3.ai.com/peers/peer0.org3.ai.com/tls/server.crt --version 1 --sequence 1 --init-required
#Commit
peer lifecycle chaincode querycommitted --channelID aichannel --name fabcar_go

end=`date +"%T"`
temp1=`date -d "$begin" +%s`
temp2=`date -d "$end" +%s`
sla=`expr $temp2 - $temp1`
echo "execution time: $sla Seconds"
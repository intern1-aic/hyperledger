#this script is used to commit the chaincode in all peers..it should be run in only one peer

begin=`date +"%T"`


#peer lifecycle chaincode commit -o orderer.ai.com:7050 --tls true --cafile /repo/config/crypto-config/ordererOrganizations/ai.com/orderers/orderer.ai.com/msp/tlscacerts/tlsca.ai.com-cert.pem --channelID aichannel1 --name aichain --peerAddresses peer0.aic.ai.com:7051 --tlsRootCertFiles /repo/config/crypto-config/peerOrganizations/aic.ai.com/peers/peer0.aic.ai.com/tls/server.crt --peerAddresses peer0.bel.ai.com:7051 --tlsRootCertFiles /repo/config/crypto-config/peerOrganizations/bel.ai.com/peers/peer0.bel.ai.com/tls/server.crt --peerAddresses peer0.iiit.ai.com:7051 --tlsRootCertFiles /repo/config/crypto-config/peerOrganizations/iiit.ai.com/peers/peer0.iiit.ai.com/tls/server.crt --version 1 --sequence 1 --init-required

peer lifecycle chaincode commit -o orderer.ai.com:7050 --tls true --cafile /repo/config/crypto-config/ordererOrganizations/ai.com/orderers/orderer.ai.com/msp/tlscacerts/tlsca.ai.com-cert.pem --channelID aichannel1 --name fabcar_go --peerAddresses peer0.aic.ai.com:7051 --tlsRootCertFiles /repo/config/crypto-config/peerOrganizations/aic.ai.com/peers/peer0.aic.ai.com/tls/server.crt --peerAddresses peer0.bel.ai.com:7051 --tlsRootCertFiles /repo/config/crypto-config/peerOrganizations/bel.ai.com/peers/peer0.bel.ai.com/tls/server.crt --peerAddresses peer0.iiit.ai.com:7051 --tlsRootCertFiles /repo/config/crypto-config/peerOrganizations/iiit.ai.com/peers/peer0.iiit.ai.com/tls/server.crt --version 1 --sequence 1 --init-required
#Commit
peer lifecycle chaincode querycommitted --channelID aichannel1 --name fabcar_go

end=`date +"%T"`
temp1=`date -d "$begin" +%s`
temp2=`date -d "$end" +%s`
sla=`expr $temp2 - $temp1`
echo "execution time: $sla Seconds"
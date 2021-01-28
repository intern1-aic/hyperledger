

peer lifecycle chaincode commit -o orderer.ai.com:7050 --tls true --cafile /repo/config/crypto-config/ordererOrganizations/ai.com/orderers/orderer.ai.com/msp/tlscacerts/tlsca.ai.com-cert.pem --channelID channel1 --name fabcar_1 --peerAddresses peer0.aic.ai.com:7051 --tlsRootCertFiles /repo/config/crypto-config/peerOrganizations/aic.ai.com/peers/peer0.aic.ai.com/tls/server.crt --version 1 --sequence 1 --init-required
peer lifecycle chaincode querycommitted --channelID channel4 --name fabcar_1

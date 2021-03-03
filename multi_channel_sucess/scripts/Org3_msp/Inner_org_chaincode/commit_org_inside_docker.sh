

peer lifecycle chaincode commit -o orderer3.ai.com:9050 --tls true --cafile /repo/config/crypto-config/ordererOrganizations/ai.com/orderers/orderer3.ai.com/msp/tlscacerts/tlsca.ai.com-cert.pem --channelID channel3 --name fabcar_3 --peerAddresses peer0.iiit.ai.com:7051 --tlsRootCertFiles /repo/config/crypto-config/peerOrganizations/iiit.ai.com/peers/peer0.iiit.ai.com/tls/server.crt --version 1 --sequence 1 --init-required
peer lifecycle chaincode querycommitted --channelID channel3 --name fabcar_3
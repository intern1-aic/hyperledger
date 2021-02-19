

peer lifecycle chaincode commit -o orderer2.ai.com:8050 --tls true --cafile /MSP_Org2/config/crypto-config/ordererOrganizations/ai.com/orderers/orderer2.ai.com/msp/tlscacerts/tlsca.ai.com-cert.pem --channelID channel2 --name fabcar_2 --peerAddresses peer0.bel.ai.com:7051 --tlsRootCertFiles /MSP_Org2/config/crypto-config/peerOrganizations/bel.ai.com/peers/peer0.bel.ai.com/tls/server.crt --version 1 --sequence 1 --init-required
peer lifecycle chaincode querycommitted --channelID channel2 --name fabcar_2

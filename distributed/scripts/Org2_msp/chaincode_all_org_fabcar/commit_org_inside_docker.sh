

peer lifecycle chaincode commit -o orderer4.ai.com:10050 --tls true --cafile /MSP_Org2/config/crypto-config/ordererOrganizations/ai.com/orderers/orderer.ai.com/msp/tlscacerts/tlsca.ai.com-cert.pem --channelID channel4 --name fabcar_go-all --peerAddresses peer0.aic.ai.com:7051 --tlsRootCertFiles /MSP_Org2/config/crt/org1/server.crt --peerAddresses peer0.bel.ai.com:7051 --tlsRootCertFiles /MSP_Org2/config/crt/org2/server.crt --peerAddresses peer0.iiit.ai.com:7051 --tlsRootCertFiles /MSP_Org2/config/crt/org3/server.crt --version 1 --sequence 1 --init-required
peer lifecycle chaincode querycommitted --channelID channel4 --name fabcar_go-all
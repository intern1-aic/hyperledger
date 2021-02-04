

peer lifecycle chaincode queryinstalled
echo "enter the package Id"
read PACKAGE_ID
peer lifecycle chaincode approveformyorg --tls --cafile /repo/config/crypto-config/ordererOrganizations/ai.com/orderers/orderer.ai.com/msp/tlscacerts/tlsca.ai.com-cert.pem --channelID channel1 --name fabcar_1 --version 1 --init-required --package-id $PACKAGE_ID --sequence 1 --waitForEvent
peer lifecycle chaincode checkcommitreadiness --channelID channel1 --name fabcar_1 --version 1 --sequence 1 --output json --init-required
		
		

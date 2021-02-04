

peer lifecycle chaincode queryinstalled
echo "enter the package Id"
read PACKAGE_ID
peer lifecycle chaincode approveformyorg --tls --cafile /repo/config/crypto-config/ordererOrganizations/ai.com/orderers/orderer3.ai.com/msp/tlscacerts/tlsca.ai.com-cert.pem --channelID channel3 --name fabcar_3 --version 1 --init-required --package-id $PACKAGE_ID --sequence 1 --waitForEvent
peer lifecycle chaincode checkcommitreadiness --channelID channel3 --name fabcar_3 --version 1 --sequence 1 --output json --init-required
		
		

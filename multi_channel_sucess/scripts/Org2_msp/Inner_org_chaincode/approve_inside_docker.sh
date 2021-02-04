

peer lifecycle chaincode queryinstalled
echo "enter the package Id"
read PACKAGE_ID
peer lifecycle chaincode approveformyorg --tls --cafile /repo/config/crypto-config/ordererOrganizations/ai.com/orderers/orderer2.ai.com/msp/tlscacerts/tlsca.ai.com-cert.pem --channelID channel2 --name fabcar_2 --version 1 --init-required --package-id $PACKAGE_ID --sequence 1 --waitForEvent
peer lifecycle chaincode checkcommitreadiness --channelID channel2 --name fabcar_2 --version 1 --sequence 1 --output json --init-required
		
		

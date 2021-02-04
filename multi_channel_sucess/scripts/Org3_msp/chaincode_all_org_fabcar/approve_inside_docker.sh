

peer lifecycle chaincode queryinstalled
echo "enter the package id"
read PACKAGE_ID
peer lifecycle chaincode approveformyorg --tls --cafile /repo/config/crypto-config/ordererOrganizations/ai.com/orderers/orderer4.ai.com/msp/tlscacerts/tlsca.ai.com-cert.pem --channelID channel4 --name fabcar_go-all --version 1 --init-required --package-id $PACKAGE_ID --sequence 1 --waitForEvent
peer lifecycle chaincode checkcommitreadiness --channelID channel4 --name fabcar_go-all --version 1 --sequence 1 --output json --init-required
		
		

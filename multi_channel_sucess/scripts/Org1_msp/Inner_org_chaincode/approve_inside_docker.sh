

peer lifecycle chaincode queryinstalled > log1.txt
PACKAGE_ID=`sed -n '/Package/{s/^Package ID: //; s/, Label:.*$//; p;}' log1.txt`
rm -f log1.txt
peer lifecycle chaincode approveformyorg --tls --cafile /repo/config/crypto-config/ordererOrganizations/ai.com/orderers/orderer.ai.com/msp/tlscacerts/tlsca.ai.com-cert.pem --channelID channel1 --name fabcar_1 --version 1 --init-required --package-id $PACKAGE_ID --sequence 1 --waitForEvent
peer lifecycle chaincode checkcommitreadiness --channelID channel1 --name fabcar_1 --version 1 --sequence 1 --output json --init-required "
		
		
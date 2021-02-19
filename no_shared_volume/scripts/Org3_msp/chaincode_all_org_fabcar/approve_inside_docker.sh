

peer lifecycle chaincode queryinstalled > log1.txt
grep "fabcar_go-all" log1.txt > log2.txt
PACKAGE_ID=`sed -n '/Package/{s/^Package ID: //; s/, Label:.*$//; p;}' log2.txt`
rm -f log1.txt log2.txt
peer lifecycle chaincode approveformyorg --tls --cafile /MSP_Org3/config/crypto-config/ordererOrganizations/ai.com/orderers/orderer4.ai.com/msp/tlscacerts/tlsca.ai.com-cert.pem --channelID channel4 --name fabcar_go-all --version 1 --init-required --package-id $PACKAGE_ID --sequence 1 --waitForEvent
peer lifecycle chaincode checkcommitreadiness --channelID channel4 --name fabcar_go-all --version 1 --sequence 1 --output json --init-required "
		
		
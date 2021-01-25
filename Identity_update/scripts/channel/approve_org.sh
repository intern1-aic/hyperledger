#this script is used to approve the chaincode in all peers 

begin=`date +"%T"`

peer lifecycle chaincode queryinstalled > log1.txt
PACKAGE_ID=`sed -n '/Package/{s/^Package ID: //; s/, Label:.*$//; p;}' log1.txt`
rm -f log1.txt

peer lifecycle chaincode approveformyorg --tls --cafile /repo/config/crypto-config/ordererOrganizations/ai.com/orderers/orderer.ai.com/msp/tlscacerts/tlsca.ai.com-cert.pem --channelID aichannel --name aichain --version 1 --init-required --package-id $PACKAGE_ID --sequence 1 --waitForEvent

peer lifecycle chaincode checkcommitreadiness --channelID aichannel --name aichain --version 1 --sequence 1 --output json --init-required

end=`date +"%T"`
temp1=`date -d "$begin" +%s`
temp2=`date -d "$end" +%s`
sla=`expr $temp2 - $temp1`
echo "execution time: $sla Seconds"

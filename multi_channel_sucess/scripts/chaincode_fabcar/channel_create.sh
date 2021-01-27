#this script is used to create a channel named 'aichannel1'

begin=`date +"%T"`


export CHANNEL_NAME=aichannel1
peer channel create -o orderer:7050 -c $CHANNEL_NAME -f /repo/config/channel.tx --tls --cafile /repo/config/crypto-config/ordererOrganizations/ai.com/orderers/orderer.ai.com/msp/tlscacerts/tlsca.ai.com-cert.pem
peer channel join -b aichannel1.block
peer channel update -o orderer:7050 -c $CHANNEL_NAME -f /repo/config/Org1MSPanchors.tx --tls --cafile $ORDERER_CA

end=`date +"%T"`
temp1=`date -d "$begin" +%s`
temp2=`date -d "$end" +%s`
sla=`expr $temp2 - $temp1`
echo "execution time: $sla Seconds"
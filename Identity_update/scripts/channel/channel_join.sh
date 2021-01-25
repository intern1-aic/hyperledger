#this script is used to join to a channel named 'aichannel'

begin=`date +"%T"`


export CHANNEL_NAME=aichannel
export ORDERER_CA=/repo/config/crypto-config/ordererOrganizations/ai.com/orderers/orderer.ai.com/msp/tlscacerts/tlsca.ai.com-cert.pem
peer channel fetch 0 aichannel.block -c aichannel -o orderer:7050 --tls --cafile $ORDERER_CA
peer channel join -b aichannel.block

end=`date +"%T"`
temp1=`date -d "$begin" +%s`
temp2=`date -d "$end" +%s`
sla=`expr $temp2 - $temp1`
echo "execution time: $sla Seconds"
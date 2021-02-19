
begin=`date +"%T"`
OrgName="cli-aic"
CHANNEL_NAME=channel1

kubectl get pods >> temp.txt
grep "cli-aic" temp.txt >> temp2.txt
awk '{ print $1 }' temp2.txt > temp3.txt
rm -f temp.txt temp2.txt

line=$(head -n 1 temp3.txt)

while [[ $T -eq 0 ]]; do
	kubectl exec $line -- sh -c "peer channel create -o orderer:7050 -c channel1 -f /MSP_Org1/config/channel1.tx --tls --cafile /MSP_Org1/config/Org1MSPanchors.tx --tls --cafile /MSP_Org1/config/crypto-config/ordererOrganizations/ai.com/orderers/orderer.ai.com/msp/tlscacerts/tlsca.ai.com-cert.pem"
	kubectl exec $line -- sh -c "peer channel join -b channel1.block"
	kubectl exec $line -- sh -c "peer channel list" >> list.txt 
	grep $CHANNEL_NAME list.txt
	if [[ $? -eq 0 ]]; then
		T=1
		kubectl exec $line -- sh -c "peer channel update -o orderer:7050 -c $CHANNEL_NAME -f /MSP_Org1/config/Org1MSPanchors.tx --tls --cafile /MSP_Org1/config/crypto-config/ordererOrganizations/ai.com/orderers/orderer.ai.com/msp/tlscacerts/tlsca.ai.com-cert.pem"
		
	else
		echo "an error occured..retrying.."
		sleep 4s
	fi
done
	
sed -i "/$line/d" temp3.txt
rm -f list.txt

while IFS= read -r line2; do

S=0
	while [[ $S -eq 0 ]]; do
		kubectl exec $line2 -- sh -c "peer channel fetch 0 channel1.block -c channel1 -o orderer:7050 --tls --cafile /MSP_Org1/config/crypto-config/ordererOrganizations/ai.com/orderers/orderer.ai.com/msp/tlscacerts/tlsca.ai.com-cert.pem"
		kubectl exec $line2 -- sh -c "peer channel join -b channel1.block"
		kubectl exec $line2 -- sh -c "peer channel list" >> list.txt 
		grep $CHANNEL_NAME list.txt

	if [[ $? -eq 0 ]]; then
		s=1		
		rm -f list.txt
		break	
		
	else
		echo "an error occured..retrying.."
		sleep 4s
	fi
	done
	
	rm -f list.txt

done < temp3.txt

rm temp3.txt

end=`date +"%T"`
temp1=`date -d "$begin" +%s`
temp2=`date -d "$end" +%s`
sla=`expr $temp2 - $temp1`
echo "execution time: $sla Seconds"

begin=`date +"%T"`
OrgName="cli-iiit"
CHANNEL_NAME=aichannel3

docker ps >> temp.txt
grep "k8s_cli_cli-iiit" temp.txt >> temp2.txt
awk '{ print $1 }' temp2.txt > temp3.txt
rm -f temp.txt temp2.txt

line=$(head -n 1 temp3.txt)

while [[ $T -eq 0 ]]; do
	docker exec $line /bin/sh -c "peer channel create -o orderer3:9050 -c aichannel3 -f /repo/config/aichannel3.tx --tls --cafile /repo/config/Org3MSPanchors.tx --tls --cafile /repo/config/crypto-config/ordererOrganizations/ai.com/orderers/orderer3.ai.com/msp/tlscacerts/tlsca.ai.com-cert.pem"
	docker exec $line /bin/sh -c "peer channel join -b aichannel3.block"
	docker exec $line /bin/sh -c "peer channel list" >> list.txt 
	grep $CHANNEL_NAME list.txt
	if [[ $? -eq 0 ]]; then
		T=1
		docker exec $line /bin/sh -c "peer channel update -o orderer3:9050 -c $CHANNEL_NAME -f /repo/config/Org3MSPanchors.tx --tls --cafile /repo/config/crypto-config/ordererOrganizations/ai.com/orderers/orderer3.ai.com/msp/tlscacerts/tlsca.ai.com-cert.pem"
		
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
		docker exec $line2 /bin/sh -c "peer channel fetch 0 aichannel3.block -c aichannel3 -o orderer3:9050 --tls --cafile /repo/config/crypto-config/ordererOrganizations/ai.com/orderers/orderer3.ai.com/msp/tlscacerts/tlsca.ai.com-cert.pem"
		docker exec $line2 /bin/sh -c "peer channel join -b aichannel3.block"
		docker exec $line /bin/sh -c "peer channel list" >> list.txt 
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
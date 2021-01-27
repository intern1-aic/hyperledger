#this script is used to create a channel named 'aichannnel4'


begin=`date +"%T"`
OrgName="cli-iiit"
CHANNEL_NAME=channel4
T=0

docker ps >> temp.txt
grep "k8s_cli_cli-bel-peer0" temp.txt >> temp2.txt
awk '{ print $1 }' temp2.txt > temp3.txt
rm -f temp.txt temp2.txt

line=$(head -n 1 temp3.txt)

while [[ $T -eq 0 ]]; do
	docker exec $line /bin/sh -c "peer channel fetch 0 channel4.block -c channel4 -o orderer4:10050 --tls --cafile /repo/config/crypto-config/ordererOrganizations/ai.com/orderers/orderer4.ai.com/msp/tlscacerts/tlsca.ai.com-cert.pem"
	docker exec $line /bin/sh -c "peer channel join -b channel4.block"
	docker exec $line /bin/sh -c "peer channel list" >> list.txt 
	grep $CHANNEL_NAME list.txt
	if [[ $? -eq 0 ]]; then
		T=1
		break
		
	else
		echo "an error occured..retrying.."
		rm -f list.txt
		sleep 4s
	fi
done
	
rm -f list.txt

end=`date +"%T"`
temp1=`date -d "$begin" +%s`
temp2=`date -d "$end" +%s`
sla=`expr $temp2 - $temp1`
echo "execution time: $sla Seconds"
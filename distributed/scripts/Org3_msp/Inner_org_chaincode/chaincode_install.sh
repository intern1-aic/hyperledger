#this script is used to install chaincode named fabcar


begin=`date +"%T"`
OrgName="cli-iiit"
CHANNEL_NAME=channel3
CHAINCODE_NAME=fabcar_3

kubectl get pods >> temp.txt
grep "cli-iiit" temp.txt >> temp2.txt
awk '{ print $1 }' temp2.txt > temp3.txt
rm -f temp.txt temp2.txt

while IFS= read -r line; do
    	S=0
	while [[ $S -eq 0 ]]; do
		kubectl  exec $line -- sh -c "peer lifecycle chaincode package fabcar.tar.gz --path /MSP_Org3/config/chaincode/fabcar/go/ --lang golang --label fabcar_3"
		kubectl  exec $line -- sh -c "peer lifecycle chaincode install fabcar.tar.gz "
		kubectl  exec $line -- sh -c "ls" >> list.txt 
		grep 'fabcar.tar.gz' list.txt

	if [[ $? -eq 0 ]]; then
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
#this script is used to install chaincode named fabcar


begin=`date +"%T"`
OrgName="cli-bel"
CHANNEL_NAME=channel2
CHAINCODE_NAME=fabcar_2

docker ps >> temp.txt
grep "k8s_cli_cli-bel-peer" temp.txt >> temp2.txt
awk '{ print $1 }' temp2.txt > temp3.txt
rm -f temp.txt temp2.txt

	while IFS= read -r line; do
    	S=0
	while [[ $S -eq 0 ]]; do
		docker  exec $line /bin/sh -c "peer lifecycle chaincode package fabcar.tar.gz --path /MSP_Org2/config/chaincode/fabcar/go/ --lang golang --label fabcar_2"
		docker  exec $line /bin/sh -c "peer lifecycle chaincode install fabcar.tar.gz "
		docker  exec $line /bin/sh -c "ls" >> list.txt 
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
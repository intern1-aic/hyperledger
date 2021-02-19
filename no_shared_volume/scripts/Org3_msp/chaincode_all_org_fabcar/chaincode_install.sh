#this script is used to install chaincode named fabcar


begin=`date +"%T"`
OrgName="cli-iiit"
CHANNEL_NAME=channel4
CHAINCODE_NAME=fabcar_go-all

kubectl get pods >> temp.txt
grep "cli-iiit" temp.txt >> temp2.txt
awk '{ print $1 }' temp2.txt > temp3.txt
rm -f temp.txt temp2.txt
line=$(head -n 1 temp3.txt)

S=0
	while [[ $S -eq 0 ]]; do
		kubectl exec $line -- sh -c "peer lifecycle chaincode package fabcar_go-all.tar.gz --path /MSP_Org3/config/chaincode/fabcar/go/ --lang golang --label fabcar_go-all"
		kubectl exec $line -- sh -c "peer lifecycle chaincode install fabcar_go-all.tar.gz "
		kubectl exec $line -- sh -c "ls" >> list.txt 
		grep 'fabcar_go-all.tar.gz' list.txt

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


rm temp3.txt

end=`date +"%T"`
temp1=`date -d "$begin" +%s`
temp2=`date -d "$end" +%s`
sla=`expr $temp2 - $temp1`
echo "execution time: $sla Seconds"
#this script is used to query the results

begin=`date +"%T"`
OrgName="cli-bel"
CHANNEL_NAME=channel2
CHAINCODE_NAME=fabcar_2

kubectl get pods >> temp.txt
grep "cli-bel" temp.txt >> temp2.txt
awk '{ print $1 }' temp2.txt > temp3.txt
rm -f temp.txt temp2.txt

cli=$(head -n 1 temp3.txt)

br='"'
sb="'"
args=$sb'{'$br'Args'$br':['$br'queryAllCars'$br']}'$sb

echo "Organization: bel"
echo "Chaincode: fabcar_2"
echo  " "
while IFS= read -r line; do
S=0
echo "querying container $line"
echo ""
	while [[ $S -eq 0 ]]; do

		kubectl exec  $cli -- sh -c "peer chaincode query -C channel2 -n fabcar_2 -c $args"


	if [[ $? -eq 0 ]]; then
		
		echo "--------------------------------------------------------------------------------------------------------------------------------"
		break
				
	else
		echo "an error occured..retrying.."
		sleep 4s
	fi
	done
done < temp3.txt
rm temp3.txt

end=`date +"%T"`
temp1=`date -d "$begin" +%s`
temp2=`date -d "$end" +%s`
sla=`expr $temp2 - $temp1`
echo "execution time: $sla Seconds"
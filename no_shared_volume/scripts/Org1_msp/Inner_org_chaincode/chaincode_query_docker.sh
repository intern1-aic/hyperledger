#this script is used to query the results

begin=`date +"%T"`
OrgName="cli-aic"
CHANNEL_NAME=channel1
CHAINCODE_NAME=fabcar_1

docker ps >> temp.txt
grep "k8s_cli_cli-aic-peer" temp.txt >> temp2.txt
awk '{ print $1 }' temp2.txt > temp3.txt
rm -f temp.txt temp2.txt

cli=$(head -n 1 temp3.txt)

br='"'
sb="'"
args=$sb'{'$br'Args'$br':['$br'queryAllCars'$br']}'$sb

echo "Organization: aic"
echo "Chaincode: fabcar_1"
echo  " "
while IFS= read -r line; do
S=0
echo "querying container $line"
echo ""
	while [[ $S -eq 0 ]]; do

		docker  exec  $cli /bin/sh -c "peer chaincode query -C channel1 -n fabcar_1 -c $args"


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
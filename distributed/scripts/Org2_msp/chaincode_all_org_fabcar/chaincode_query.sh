#this script is used to query the results

begin=`date +"%T"`
OrgName="cli-bel"
CHANNEL_NAME=channel4
CHAINCODE_NAME=fabcar_go-all

kubectl get pods >> temp.txt
grep "cli-bel" temp.txt >> temp2.txt
awk '{ print $1 }' temp2.txt > temp3.txt
rm -f temp.txt temp2.txt

cli=$(head -n 1 temp3.txt)

br='"'
sb="'"
args=$sb'{'$br'Args'$br':['$br'queryAllCars'$br']}'$sb


S=0
c=1
	while [[ $S -eq 0 ]]; do

		kubectl exec  $cli -- sh -c "peer chaincode query -C channel4 -n fabcar_go-all -c $args"


	if [[ $? -eq 0 ]]; then
		s=1
		break
				
	else
		echo "an error occured..retrying.."
		sleep 4s
	fi
	done

rm temp3.txt

end=`date +"%T"`
temp1=`date -d "$begin" +%s`
temp2=`date -d "$end" +%s`
sla=`expr $temp2 - $temp1`
echo "execution time: $sla Seconds"
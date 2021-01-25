#this script is used to query the results

begin=`date +"%T"`

peer chaincode query -C aichannel -n aichain -c '{"Args":["query","a"]}'

end=`date +"%T"`
temp1=`date -d "$begin" +%s`
temp2=`date -d "$end" +%s`
sla=`expr $temp2 - $temp1`
echo "execution time: $sla Seconds"
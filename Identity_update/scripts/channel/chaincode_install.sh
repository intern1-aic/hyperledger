#this script is used to install chaincode named abstore

begin=`date +"%T"`

peer lifecycle chaincode package aichain.tar.gz --path /repo/config/chaincode/abstore/javascript/ --lang node --label aichain_1
peer lifecycle chaincode install aichain.tar.gz 

end=`date +"%T"`
temp1=`date -d "$begin" +%s`
temp2=`date -d "$end" +%s`
sla=`expr $temp2 - $temp1`
echo "execution time: $sla Seconds"
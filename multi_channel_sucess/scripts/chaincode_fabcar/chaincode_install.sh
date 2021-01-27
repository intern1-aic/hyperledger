#this script is used to install chaincode named abstore

begin=`date +"%T"`

peer lifecycle chaincode package fabcar.tar.gz --path /repo/config/chaincode/fabcar/go/ --lang golang --label fabcar_go
peer lifecycle chaincode install fabcar.tar.gz 

end=`date +"%T"`
temp1=`date -d "$begin" +%s`
temp2=`date -d "$end" +%s`
sla=`expr $temp2 - $temp1`
echo "execution time: $sla Seconds"
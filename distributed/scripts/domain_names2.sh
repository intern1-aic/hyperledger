
begin=`date +"%T"`
begin_nano=`date +"%N"`

kubectl get pods -o wide > ip.txt
sed -i  '/NAME/d' ip.txt
sed -i '/cli/d' ip.txt
sed -i '/channel-binaries/d' ip.txt
awk '{ print $6 }' ip.txt > ip2.txt

kubectl get svc > name.txt
awk '{ print $1 }' name.txt > name1.txt
sed -i '/NAME/d' name1.txt
sed -i '/kubernetes/d' name1.txt

paste ip2.txt name1.txt > all.txt

grep 'orderer' all.txt > orderer.txt
sed -i '/orderer/s/$/.ai.com/' orderer.txt

sed -i '/orderer/d' all.txt
awk '{ print $2 }' all.txt > all2.txt
sed -i 's/^....//' all2.txt
sed -i 's/./&./1' all2.txt

while IFS= read -r line; do

	sed -i "s/$line/peer$line.ai.com/g" all2.txt #replaces all lines with peer$line.com in peer_svc4.txt file
	
done < all2.txt

awk '{ print $1 }' all.txt > all3.txt
paste all3.txt all2.txt > all4.txt
cat orderer.txt all4.txt > final.txt

kubectl get pods >pods.txt #gets the information of all pods
awk '{ print $1 }' pods.txt > pods2.txt #saves only the names of pods into pods2.txt file
sed -i '/NAME/d' pods2.txt #removes the heading
sed -i '/channel-binaries/d' pods2.txt

while IFS= read -r line; do
    	#echo  $line 
    	kubectl exec $line -- sh -c "echo '$(cat ./final.txt )' >> /etc/hosts"; #inserting ips and domain names in /etc/hosts of all pods one by one

    	if [ $? -eq 0 ]; then
    		echo "domain names and IP's inserted into $line : success"
    	fi
		done < pods2.txt


rm -f ip.txt ip2.txt name.txt name1.txt all.txt orderer.txt all2.txt all3.txt all4.txt final.txt pods.txt pods2.txt 



echo "finished.."
echo "______________________________________________________________________________________________________________________________________________"


end=`date +"%T"`
end_nano=`date +"%N"`
nano_diff=`expr $end_nano - $begin_nano`
nano_diff=${nano_diff#-}
milli_seconds=`expr $nano_diff / 1000000`
begin_seconds=`date -d "$begin" +%s`
end_seconds=`date -d "$end" +%s`
execution_seconds=`expr $end_seconds - $begin_seconds`
echo "execution time: $execution_seconds.$milli_seconds Seconds"

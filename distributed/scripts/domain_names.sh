begin=`date +"%T"`
begin_nano=`date +"%N"`

echo "//////////////////////////////////////////////////////////////////////////////////////////////////////////"
echo "----Inserting the clusterIP's of pods along with their domain names into /etc/hosts of all pods-----------"
echo "||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||" 


kubectl get svc > svc.txt #fetch cluster ip's for each pods
awk '{ print $3 }' svc.txt > svc1.txt #cuts the 3rd colum which contains the IP's

awk '{ print $1 }' svc.txt > svc2.txt #cuts the first colum which contains the names 

paste svc1.txt svc2.txt >svc3.txt #svc3.txt is contains names and ip address of all pods

sed -i '/NAME/d' svc3.txt #cuts the colum heading
sed -i '/kubernetes/d' svc3.txt #removes the pod named kubernetes, we don't use that pod anymore
sed -i '/peer/d' svc3.txt #cuts the peer pods
sed -i '/orderer/s/$/.ai.com/' svc3.txt #giving domain names for all orderer pods ie, the svc3.txt contains only the domain names and IP's of orderer pods

#kubectl get svc > svc_peer.txt 
awk '{ print $3 }' svc.txt > peer_svc1.txt #again cuts the 3rd colum from svc.txt
awk '{ print $1 }' svc.txt > peer_svc2.txt #cuts the first colum from svc.txt


paste peer_svc1.txt peer_svc2.txt >peer_svc3.txt #merge the two files and the resulting file peer_svc3.txt contains the name and IP's of all pods



sed -i '/NAME/d' peer_svc3.txt #deletes the colum heading
sed -i '/kubernetes/d' peer_svc3.txt #removes the pod named kubernetes
sed -i '/orderer/d' peer_svc3.txt #removes all orderer pods
awk '{ print $2 }' peer_svc3.txt >peer_svc4.txt #saves the second colum into peer_svc4.txt for further use
sed -i 's/^....//' peer_svc4.txt #removes the first 4 characters from all lines of peer_svc4.txt
sed -i 's/./&./1' peer_svc4.txt  #adding a '.' as second character


while IFS= read -r line; do

	sed -i "s/$line/peer$line.ai.com/g" peer_svc4.txt #replaces all lines with peer$line.com in peer_svc4.txt file
	
done < peer_svc4.txt

awk '{ print $1 }' peer_svc3.txt > peer_svc5.txt #cuts the first colum from peer_svc3.txt into peer_svc5.txt file
paste peer_svc5.txt peer_svc4.txt > peer_svc6.txt #merges peer_svc5.txt and peer_svc4.txt into peer_svc6.txt file
cat svc3.txt peer_svc6.txt > final.txt

kubectl get pods >pods.txt #gets the information of all pods
awk '{ print $1 }' pods.txt > pods2.txt #saves only the names of pods into pods2.txt file
sed -i '/NAME/d' pods2.txt #removes the heading


	while IFS= read -r line; do
    	#echo  $line 
    	kubectl exec $line -- sh -c "echo '$(cat ./final.txt )' >> /etc/hosts"; #inserting ips and domain names in /etc/hosts of all pods one by one

    	if [ $? -eq 0 ]; then
    		echo "domain names and IP's inserted into $line : success"
    	fi
		done < pods2.txt
#removes all the text files that created for adding domain names 

echo "You can varify the domain names and cluster IP's are inserted correctly.."
echo "The inserted domain names are :"
cat final.txt
echo "you can compare the above information with the output of 'kubectl get svc'"
rm -f svc.txt svc1.txt svc2.txt svc3.txt
rm -f svc_peer.txt peer_svc1.txt peer_svc2.txt peer_svc3.txt peer_svc4.txt peer_svc5.txt peer_svc6.txt final.txt
rm -f pods.txt pods2.txt
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
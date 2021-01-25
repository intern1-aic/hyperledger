parse_yaml() {
   local prefix=$2
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|^\($s\)\($w\)$s:$s\"\(.*\)\"$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
      }
   }'
}


 eval $(parse_yaml ./config/config.yaml "org_")
 channel_name=$org_Channels_channel1_name
 chain_code=$org_Chaincode_name

kubectl get pods > cli1.txt
awk '{ print $1 }' cli1.txt > cli2.txt
sed -i '/orderer/d' cli2.txt 
sed -i '/NAME/d' cli2.txt
grep 'cli' cli2.txt > cli3.txt
grep 'cli' cli2.txt > cli4.txt
grep 'peer0' cli4.txt > cli5.txt


check="false"

while [[ $check != "true" ]]; do
	while IFS= read -r line2; do
       
	time kubectl exec $line2 -- sh /repo/config/channel/channel_create.sh
	kubectl exec $line2 -- sh -c "peer channel list" > temp.txt
	grep "$channel_name" temp.txt
	if [[ $? -eq 0 ]]; then
		check="true"
	fi
	rm -f temp.txt
	break
done < cli3.txt
done

sed -i "/$line2/d" cli3.txt

count=0
while IFS= read -r line2; do
  count=$((count+1))
done < cli3.txt

echo "sleep 2s"
sleep 2s
count2=0
while [[ $count2 -ne $count ]]; do
	while IFS= read -r line3; do
	    sleep 2s  
		time kubectl exec $line3 -- sh /repo/config/channel/channel_join.sh
		kubectl exec $line3 -- sh -c "peer channel list" > temp.txt
		grep "$channel_name" temp.txt
		if [[ $? -eq 0 ]]; then
		sed -i "/$line3/d" cli3.txt
		count2=$((count2+1))
	    fi
	    rm -f temp.txt
	done < cli3.txt
done


check3="false"
count3=0
count4=0

while IFS= read -r line2; do
  count3=$((count3+1))
done < cli4.txt

while [[ $count3 -ne $count4 ]]; do
	while IFS= read -r line4; do
       
	time kubectl exec $line4 -- sh /repo/config/channel/chaincode_install.sh
	kubectl exec $line4 -- sh -c "ls" > chain.txt
	grep "$chain_code" chain.txt
	if [[ $? -eq 0 ]]; then
		count4=$((count4+1))
		sed -i "/$line4/d" cli4.txt
	fi
	rm -f chain.txt
	echo sleep 2s
	sleep 2s

done < cli4.txt
done

sleep 3s

while IFS= read -r line; do

	time kubectl exec $line -- sh /repo/config/channel/approve_org.sh
	echo sleep 2s
	sleep 3s

done < cli5.txt
sleep 3s
while IFS= read -r line; do

	time kubectl exec $line -- sh /repo/config/channel/commit_org.sh
	if [ $? -eq 0 ]; then 
	break
	fi

done < cli5.txt

while IFS= read -r line; do

	time kubectl exec $line -- sh /repo/config/channel/chaincode_init.sh
	if [ $? -eq 0 ]; then 
	break
	fi

done < cli5.txt


rm -f cli1.txt cli2.txt cli3.txt cli4.txt cli5.txt


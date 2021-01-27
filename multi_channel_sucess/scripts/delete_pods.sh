begin=`date +"%T"`
begin_nano=`date +"%N"`

kubectl get pods > pods.txt

awk '{ print $1 }' pods.txt > pods2.txt

sed '1d' pods2.txt > pods3.txt

rm -f pods.txt

rm -f pods2.txt

	while IFS= read -r line; do
    	#echo  $line 
    	kubectl delete pods $line

	done < pods3.txt

end=`date +"%T"`
end_nano=`date +"%N"`
nano_diff=`expr $end_nano - $begin_nano`
nano_diff=${nano_diff#-}
milli_seconds=`expr $nano_diff / 1000000`
begin_seconds=`date -d "$begin" +%s`
end_seconds=`date -d "$end" +%s`
execution_seconds=`expr $end_seconds - $begin_seconds`
echo "execution time: $execution_seconds.$milli_seconds Seconds"
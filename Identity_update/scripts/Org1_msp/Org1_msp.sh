#this script is used to generate the msp and essential binaries for fabric 2.0

begin=`date +"%T"`
begin_nano=`date +"%N"`
#sudo chmod -R a+rwx /repo


 if [ -e ./crypto-config ]; then

         rm -r ./crypto-config
 fi



/repo/bin/cryptogen generate --config=./crypto-config.yaml
cp -R ./crypto-config/peerOrganizations/org1.ai.com/ /repo/config/crypto-config/peerOrganizations


echo "files generated successfully.."

echo "copied to /repo/config"


end=`date +"%T"`
end_nano=`date +"%N"`
nano_diff=`expr $end_nano - $begin_nano`
nano_diff=${nano_diff#-}
milli_seconds=`expr $nano_diff / 1000000`
begin_seconds=`date -d "$begin" +%s`
end_seconds=`date -d "$end" +%s`
execution_seconds=`expr $end_seconds - $begin_seconds`
echo "execution time: $execution_seconds.$milli_seconds Seconds"
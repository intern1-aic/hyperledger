#this script is used to generate the msp and essential binaries for fabric 2.0

# begin=`date +"%T"`
# begin_nano=`date +"%N"`
sudo chmod -R a+rwx /repo

 if [ -e ./crypto-config ]; then

         rm -r ./crypto-config
 fi



/repo/bin/cryptogen generate --config=./crypto-config.yaml



#Anchor


mkdir -p /repo/config/crypto-config/peerOrganizations

cp -r ./crypto-config /repo/config

cp -r ./chaincode /repo/config

cp -r ../chaincode_fabcar /repo/config

cp -r ../Org1_msp /repo

cp -r ../Org2_msp /repo

cp -r ../Org3_msp /repo

rm -r ./crypto-config

# sudo chmod -R 777 /repo/
# echo "files generated successfully.."

# echo "copied to /repo/config"


# end=`date +"%T"`
# end_nano=`date +"%N"`
# nano_diff=`expr $end_nano - $begin_nano`
# nano_diff=${nano_diff#-}
# milli_seconds=`expr $nano_diff / 1000000`
# begin_seconds=`date -d "$begin" +%s`
# end_seconds=`date -d "$end" +%s`
# execution_seconds=`expr $end_seconds - $begin_seconds`
# echo "execution time: $execution_seconds.$milli_seconds Seconds"
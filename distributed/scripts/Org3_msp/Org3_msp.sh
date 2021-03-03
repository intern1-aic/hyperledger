					#this script is used to generate the msp and essential binaries for fabric 2.0

begin=`date +"%T"`
begin_nano=`date +"%N"`
#sudo chmod -R a+rwx /repo


if [ ! -e /MSP_Org3 ]; then
	sudo mkdir /MSP_Org3
	sudo chmod -R a+rwx /MSP_Org3
else
	sudo chmod -R a+rwx /MSP_Org3
fi

 if [ -e ./crypto-config ]; then

         rm -r ./crypto-config
 fi

sudo rm -rf /MSP_Org3/*
mkdir /MSP_Org3/config
./bin/cryptogen generate --config=./crypto-config.yaml
mv ./crypto-config /MSP_Org3/config/crypto-config

echo "files generated successfully.."

echo "copied to /MSP_Org3/config"

end=`date +"%T"`
end_nano=`date +"%N"`
nano_diff=`expr $end_nano - $begin_nano`
nano_diff=${nano_diff#-}
milli_seconds=`expr $nano_diff / 1000000`
begin_seconds=`date -d "$begin" +%s`
end_seconds=`date -d "$end" +%s`
execution_seconds=`expr $end_seconds - $begin_seconds`
echo "execution time: $execution_seconds.$milli_seconds Seconds"

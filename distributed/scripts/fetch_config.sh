#!/bin/sh

# include parse_yaml function
#./parse_yaml.sh


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

# read yaml file
eval $(parse_yaml ../config/config.yaml "config_")

# access yaml content

NewOrg1=$config_Org1_name
temp=$NewOrg1
NewOrg1=$(echo $NewOrg1 | sed 's/ //g')
NewOrg1=$(echo "$NewOrg1" | tr '[:upper:]' '[:lower:]')
sed -i "s/$temp/$NewOrg1/g" ../config/config.yaml
NewOrg2=$config_Org2_name
temp=$NewOrg2
NewOrg2=$(echo $NewOrg2 | sed 's/ //g')
NewOrg2=$(echo "$NewOrg2" | tr '[:upper:]' '[:lower:]')
sed -i "s/$temp/$NewOrg2/g" ../config/config.yaml
NewOrg3=$config_Org3_name
temp=$NewOrg3
NewOrg3=$(echo $NewOrg3 | sed 's/ //g')
NewOrg3=$(echo "$NewOrg3" | tr '[:upper:]' '[:lower:]')
sed -i "s/$temp/$NewOrg3/g" ../config/config.yaml
#New


NewChannelName1=$config_Channels_blockchannel1_name
temp=$NewChannelName1
NewChannelName1=$(echo $NewChannelName1 | sed 's/ //g')
NewChannelName1=$(echo "$NewChannelName1" | tr '[:upper:]' '[:lower:]')
sed -i "s/$temp/$NewChannelName1/g" ../config/config.yaml
NewChannelName2=$config_Channels_blockchannel2_name
temp=$NewChannelName2
NewChannelName2=$(echo $NewChannelName2 | sed 's/ //g')
NewChannelName2=$(echo "$NewChannelName2" | tr '[:upper:]' '[:lower:]')
sed -i "s/$temp/$NewChannelName2/g" ../config/config.yaml
NewChannelName3=$config_Channels_blockchannel3_name
temp=$NewChannelName3
NewChannelName3=$(echo $NewChannelName3 | sed 's/ //g')
NewChannelName3=$(echo "$NewChannelName3" | tr '[:upper:]' '[:lower:]')
sed -i "s/$temp/$NewChannelName3/g" ../config/config.yaml
NewChannelName4=$config_Channels_blockchannel4_name
temp=$NewChannelName4
NewChannelName4=$(echo $NewChannelName4 | sed 's/ //g')
NewChannelName4=$(echo "$NewChannelName4" | tr '[:upper:]' '[:lower:]')
sed -i "s/$temp/$NewChannelName4/g" ../config/config.yaml

NewChaincodeOrg1=$config_Org1_chaincode
NewChaincodeOrg2=$config_Org2_chaincode
NewChaincodeOrg3=$config_Org3_chaincode
NewChaincodeAllOrg=$config_InterOrg_chaincode

echo $NewChaincodeOrg1
echo $NewChaincodeOrg2
echo $NewChaincodeOrg3
echo $NewChaincodeAllOrg



eval $(parse_yaml ../config/temp.yaml "config_")

OldOrg1=$config_Org1_name
OldOrg2=$config_Org2_name
OldOrg3=$config_Org3_name
#Old

OldChannelName1=$config_Channels_blockchannel1_name
OldChannelName2=$config_Channels_blockchannel2_name
OldChannelName3=$config_Channels_blockchannel3_name
OldChannelName4=$config_Channels_blockchannel4_name

OldChaincodeOrg1=$config_Org1_chaincode
OldChaincodeOrg2=$config_Org2_chaincode
OldChaincodeOrg3=$config_Org3_chaincode
OldChaincodeAllOrg=$config_InterOrg_chaincode



while IFS= read -r line; do
                  
sed -i "s/$OldOrg1/$NewOrg1/g" $line
sed -i "s/$OldOrg2/$NewOrg2/g" $line
sed -i "s/$OldOrg3/$NewOrg3/g" $line
#Loop
sed -i "s/$OldChannelName1/$NewChannelName1/g" $line
sed -i "s/$OldChannelName2/$NewChannelName2/g" $line
sed -i "s/$OldChannelName3/$NewChannelName3/g" $line
sed -i "s/$OldChannelName4/$NewChannelName4/g" $line
sed -i "s/$OldChaincodeOrg1/$NewChaincodeOrg1/g" $line
sed -i "s/$OldChaincodeOrg2/$NewChaincodeOrg2/g" $line
sed -i "s/$OldChaincodeOrg3/$NewChaincodeOrg3/g" $line
sed -i "s/$OldChaincodeAllOrg/$NewChaincodeAllOrg/g" $line
done < files.blit



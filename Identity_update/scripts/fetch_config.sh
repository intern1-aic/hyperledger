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
sed -i "s/$temp/$NewOrg1/g" ../config/config.yaml
NewOrg2=$config_Org2_name
temp=$NewOrg2
NewOrg2=$(echo $NewOrg2 | sed 's/ //g')
sed -i "s/$temp/$NewOrg2/g" ../config/config.yaml
NewOrg3=$config_Org3_name
temp=$NewOrg3
NewOrg3=$(echo $NewOrg3 | sed 's/ //g')
sed -i "s/$temp/$NewOrg3/g" ../config/config.yaml
#New

NewChannelName=$config_Channels_channel1_name
NewChaincodeName=$config_Chaincode_name



eval $(parse_yaml ../config/temp.yaml "config_")

OldOrg1=$config_Org1_name
OldOrg2=$config_Org2_name
OldOrg3=$config_Org3_name
#Old

OldChannelName=$config_Channels_channel1_name
OldChaincodeName=$config_Chaincode_name



while IFS= read -r line; do
                  
sed -i "s/$OldOrg1/$NewOrg1/g" $line
sed -i "s/$OldOrg2/$NewOrg2/g" $line
sed -i "s/$OldOrg3/$NewOrg3/g" $line
#Loop
sed -i "s/$OldChannelName/$NewChannelName/g" $line
sed -i "s/$OldChaincodeName/$NewChaincodeName/g" $line
done < files.blit




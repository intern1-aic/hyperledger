#this script is used to create the file structure in /repo/config


mkdir -p /repo/config/crypto-config/peerOrganizations

cp -r ./crypto-config /repo/config

cp -r ./chaincode /repo/config

cp -r ../chaincode_fabcar /repo/config

cp -r ./channel /repo/config

cp -r ../Org1_msp /repo/config

cp -r ../Org2_msp /repo/config

cp -r ../Org3_msp /repo/config

rm -r ./crypto-config
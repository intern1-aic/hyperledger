#this script is used to get inside of a docker container in worker nodes

function executeContainer()
{

	s="$1"
	peer="peer$s"
	docker ps >> temp.txt
	grep "k8s_cli_cli-iiit-$peer" temp.txt >> temp2.txt
	awk '{ print $1 }' temp2.txt > temp3.txt
	rm -f temp.txt temp2.txt
	line=$(head -n 1 temp3.txt)
	rm -f temp3.txt
	echo "You are inside on $peer iiit:Organiaztion"
	docker exec -it $line /bin/sh

}

echo "==========================================================================================="
echo "------------------------------Docker containers--------------------------------------------"
echo "==========================================================================================="

echo "Select any one of the peer from the following"
            echo " ________________________________________________ "
			echo "|                                                |"
			echo "|                 Organiaztion: iiit               "
			echo "|                                                |"
			echo "|                 1. peer0                       |"  
			echo "|                                                |"
			echo "|                 2. peer1                       |"
			echo "|                                                |"
			echo "|                 3. peer2                       |"                 
			echo "|                                                |"
			echo "|________________________________________________|"

read UserChoice

if [[ -n ${UserChoice//[0-9]/} ]]; then
    echo "You can select the peer with its index number ( 1, 2, 3)"
    exit 1
fi


if [ $UserChoice -eq 1 ]
then
	
	executeContainer 0


elif [ $UserChoice -eq 2 ]
then

	executeContainer 1
	


elif [ $UserChoice -eq 3 ]
then

	executeContainer 2
	
else
	echo "Incorrect choice"
	exit 1
fi



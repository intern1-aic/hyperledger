#this script is used to get inside of a docker container in worker nodes


echo "==========================================================================================="
echo "------------------------------Docker contatiers--------------------------------------------"
echo "==========================================================================================="

echo "Select any one of the peer from the following"
            echo " ________________________________________________ "
			echo "|                                                |"
			echo "|                 Organiaztion: aic               "
			echo "|                                                |"
			echo "|                 1. peer0                       |"  
			echo "|                                                |"
			echo "|                 2. peer1                       |"
			echo "|                                                |"
			echo "|                 3. peer2                       |"                 
			echo "|                                                |"
			echo "|________________________________________________|"

read UserChoice

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

function executeContainer($peerNumber)
{

	echo $peerNumber

}

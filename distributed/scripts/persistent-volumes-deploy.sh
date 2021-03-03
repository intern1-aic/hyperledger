#this script is used to deploy persistent volumes to kubernetes cluster

kubectl apply -f ../volumes/fabric-pv1.yaml
kubectl apply -f ../volumes/fabric-pvc1.yaml
kubectl apply -f ../volumes/fabric-pv2.yaml
kubectl apply -f ../volumes/fabric-pvc2.yaml
kubectl apply -f ../volumes/fabric-pv3.yaml
kubectl apply -f ../volumes/fabric-pvc3.yaml
kubectl apply -f ./channel-helper-pod-org1.yaml
kubectl apply -f ./channel-helper-pod-org2.yaml
kubectl apply -f ./channel-helper-pod-org3.yaml
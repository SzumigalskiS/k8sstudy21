# create new docker folder docker-args and modify the Dockerfile as well the fortuneloop.sh file
# 1change this line -- ENTRYPOINT /bin/fortuneloop.sh -> ENTRYPOINT ["/bin/fortuneloop.sh"]
# add this line --    CMD ["10"]
# few changes inside the fortuneloop.sh file 
# run 
cd docker-args
docker build -t szumigalskis/fortune:args .
docker push szumigalskis/fortune:args

# we can now run the docker run command and specify the interval we specify in CMD part - 10 second 
docker run -it szumigalskis/fortune:args

# because we change our fortuneloop.sh now we can overwrite the CMD value by providing it during docker run command
docker run -it szumigalskis/fortune:args 15

# we can achive same by adding new agruments to the Pod manifest file for the container
# vim 01-fortune2s.yaml
kubectl apply -f 01-fortune2s.yaml


# another way is to specify the environment variable for the container
# modify the fortuneloop.sh file by removing line 3
# run docker build to create new image with the env tag
cd docker-env
docker build -t szumigalskis/fortune:env .
docker push szumigalskis/fortune:env

# create new Pod manifest file - 02-fortune30s-pod.yaml
# add the env var to it
vim 02-fortune30s-pod.yaml

kubectl apply -f 02-fortune30s-pod.yaml

#to check that file is created and refresh by the time we specify
kubectl exec fortune-env -c html-generator -- ls /var/htdocs
kubectl exec fortune-env -c html-generator -- cat /var/htdocs/index.html

#expose the pod to be able access from webpage
kubectl expose pod fortune-env --name=fortune-svc --type=NodePort

#run this command and check which worker node the pod is running
kubectl get pod -o wide

#run this command to check the worker node IP 
kubectl get node -o wide

kubectl get svc
~
#open website
http://<worker IP>:<port>

# all above steps are very manual and error prompt we can use another way
# Kubernetes contain object call configMap -  script

# configMap can contain configuration data for our container inside pod

kubectl create configmap mymap --from-literal shortname=k8s.io --from-literal longname=kubernetes.io

kubectl get cm mymap
kubectl describe cm mymap

#create configMap from manifest file
kubectl apply -f 03-mymap.yaml
kubectl get cm mymap-yaml

# example how we can use the config map inside pod
cat 05-envpod.yaml
kubectl apply -f 05-envpod.yaml

kubectl exec envpod -- env |grep NAME

# we can use the configMap and add it to Pod container as volume
kubectl apply -f 06-cmvol.yaml
kubectl exec cmvol -- ls /etc/name
kubectl exec cmvol -- cat /etc/name/firstname

# we can create configMap from the file 
kubectl create configmap cm-fromfile --from -file=config-file.config
kubectl describe configmap cm-fromfile

# create config map to use with Pod
kubectl create configmap fortune-config --from-literal=sleep-interval=25

kubectl describe cm fortune-config

kubectl apply -f 07-fortune-env-cmpod.yaml


# Secrets
# display the current secrets inside K8s cluster
kubectl get secrets
kubectl describe secrets

# check pod that there is information store at the secret mount volume 
kubectl exec envpod -- ls /var/run/secrets/kubernetes.io/serviceaccount/
kubectl exec envpod -- cat /var/run/secrets/kubernetes.io/serviceaccount/token

# create secret with username and password to use with database 
kubectl create secret generic db-secret --from-literal=dbhost=sql02 --from-literal=dbuser=root --from-literal=db_password=Password0123
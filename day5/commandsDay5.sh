# DAY 5


# create the pod manifest file with two containers 
kubectl apply -f fortune-pod.yaml

kubectl expose pod fortune --type=NodePort --name=fortune-svc

# go to the webpage using IP of the worker on which the pod is running
kubectl get pod fortune -o wide

# example output of the above command
NAME      READY   STATUS    RESTARTS   AGE   IP           NODE        NOMINATED NODE   READINESS GATES
fortune   2/2     Running   2          15h   10.244.0.4   k8snode03   <none>           <none>

kubectl get svc fortune-svc
# example output of above command
NAME          TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
fortune-svc   NodePort   10.108.171.3   <none>        80:31292/TCP   15h

kubectl get node k8snode03 -o wide
# example output of the above command, we run this command only for node03 as this node on which our application is running
NAME        STATUS   ROLES    AGE     VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION       CONTAINER-RUNTIME
k8snode03   Ready    <none>   2d23h   v1.18.4   192.168.1.18   <none>        Ubuntu 18.04.4 LTS   4.15.0-106-generic   docker://19.3.6

# open website and go to the IP address of the worker node running the application folow by port of the service
http://<worker IP>:<NodePort> 

# we can use the command to check is our application is working
curl http://<worker IP>:<NodePort>

# above exercise was to prove that two containers inside one pod can share the same volume
# we can ssh to the worker node and check that there is a new directory created in the location specified by us in pod manifest file
# running ls command on we can see that the directory contain file created by the container
# we can as well access the containers and check the files

# below command will be attached to the pod/container and list the directory; another command will show what is inside the file
kubectl exec fortune -c html-generator -- ls /var/htdocs

kubectl exec fortune -c html-generator -- cat /var/htdocs/index.html



# create Persistent Volume claim - file 03-pv-log.yaml
kubectl apply -f 03-pv-log.yaml

Kubectl get pv 
# we can us pv as alias to persistentvolume
# output of the above command showing to as that the persistent volume was created and is available for claim
NAME     CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS   REASON   AGE
pv-log   100Mi      RWX            Retain           Available                                   5s

#create PersistentVolumeClaim - file 04-pvc-log.yaml
kubectl apply -f 04-pvc-log.yaml

kubectl get pvc
# output of the above command show as that the claim was bound to persistent volume pv-log
NAME        STATUS   VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   AGE
claim-log   Bound    pv-log   100Mi      RWX                           11s

# running the command again will show us that the pv status is bound now
kubectl get pv
NAME     CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM               STORAGECLASS   REASON   AGE
pv-log   100Mi      RWX            Retain           Bound    default/claim-log                           4m19s

# create pod to use the volume claim - file 05-web-pod-pvc.yaml
kubectl apply -f 05-web-pod-pvc.yaml

kubectl get pod webapp
# output of the above command
NAME     READY   STATUS    RESTARTS   AGE   IP           NODE        NOMINATED NODE   READINESS GATES
webapp   1/1     Running   0          22s   10.244.0.4   k8snode02   <none>           <none>

# now if we ssh to the worker node on which the pod is running we can see the flies created inside the directory /pv/log 

# Create storage class
kubectl apply -f 06-fast.yaml
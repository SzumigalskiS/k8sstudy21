# Node maintenance

kubectl get nodes
kubectl drain k8snode01
kubectl uncordon k8snode01

kubectl taint nodes k8snode01 node-role.kubernetes.io/master:NoSchedule #default taint on master node
kubectl taint nodes k8snode01 node-role.kubernetes.io/master:NoSchedule-


node.kubernetes.io/not-ready: #Node is not ready. This corresponds to the NodeCondition Ready being "False".
node.kubernetes.io/unreachable: #Node is unreachable from the node controller. This corresponds to the NodeCondition Ready being "Unknown".
node.kubernetes.io/out-of-disk: #Node becomes out of disk.
node.kubernetes.io/memory-pressure: #Node has memory pressure.
node.kubernetes.io/disk-pressure: #Node has disk pressure.
node.kubernetes.io/network-unavailable: #Node's network is unavailable.
node.kubernetes.io/unschedulable: #Node is unschedulable.


# Pod resouces and limits 
# we can specify the resources limits for pod to use
kubectl apply -f 01-resouces.yaml

# job creation
# we can create job to run some operation, job will spin up pod and run it untill the job is compleated
kubectl apply -f 03-job.yaml

pods=$(kubectl get pods --selector=job-name=pi --output=jsonpath='{.items[*].metadata.name}')
echo $pods
kubectl logs $pods

#CronJobs are useful for creating periodic and recurring tasks, like running backups or sending emails. 
#CronJobs can also schedule individual tasks for a specific time, such as scheduling a Job for when 
#your cluster is likely to be idle.
kubectl apply -f 03-cronjob.yaml

# assign pod to the node - node selector
kubectl label nodes <node-name> <label-key>=<label-value>
kubectl label nodes k8snode01 disktype=ssd


# assign service account to the pod
# when creating the pod the default service account will be assign to the pod

kubectl get serviceaccount # short sa
kubectl apply -f 09-serviceaccount.yaml
kubectl apply -f 10-podsa.yaml 
kp pod-sa -o yaml |grep serviceAccount:


# static pod
# we can create pod statically assin to the node
ssh chefadmin@k8snode02

#copy the 11-staticpod.yaml to /etc/kubernetes/manifests
# pod will be automatically created by kubelet on that node, deleting pod from master node the pod will
# be created again


# Scenario 1
# Create Pod webapp running nginx containers and using port 81 for traffice

# Scenario 2
# Expose pod webapp by using NodePort service

# Scenario 3
# Create deployment myapp with 10 pods running alpine image

# Scenario 4
# Create pod runnig 2 containers using nginx and alpine image, schedule the pod on worker node 3
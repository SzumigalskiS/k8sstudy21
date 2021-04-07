# DAY 3

# kubectl commands
# IMPORTANT learn how to create alias
alias k=kubectl
alias kgp="kubectl get pods"
alias kgn="k get nodes"
alias kgd="k get deploy"
alias kd="k describe"
alias ka="k apply -f"

# how to create token to join new worker to the cluster
sudo kubeadm token list
kubeadm token generate
kubeadm token create 54929n.szmhl6jjllvdb0ru --ttl 2h --print-join-command

#namespaces 
kubectl get namespaces
#all new resources if not specify goes to the default namespace
#kube-system is the namespace for control plane we should not change anything there

#listing nodes in the cluster
kubectl get nodes
#not with status NotReady have some problems, and we should fix it
#example of troubleshooting
kubectl get nodes -o wide
kubectl get nodes k8snode01 -o yaml > k8snode01.yaml
kubectl get nodes k8snode02 -o json


#list all supported resources
kubectl api-resources


# easier way to create a pod, but actually, it creates a deployment
kubectl run nginx --image=nginx

kubectl get deployment
kubectl get pod

kubectl describe deploy nginx
kubectl describe pod nginx

# create single pod
kubectl run nginx --image=nginx --restart=Never

# create YAML file from running pod
kubectl get pod nginx -o yaml
kubectl get pod nginx -o yaml >> nginx.yaml

#get help fo creating the service
kubectl expose -h

# expose the pod Nginx
kubectl expose pod nginx 

# we need to modify our pod manifest file and add container port
# add below line under the container spec, we cannot modify the pod on fly pod need to be deleted and recreated
ports:
   - containerPort: 80
     protocol: TCP 

kubectl delete pod nginx
kubectl apply -f nginx.yaml
kubectl expose pod nginx

# list the new service created, by default k8s create ClusterIP service
kubectl get service
kubectl get endpoints

# we can now test that we can talk to our Nginx pod we should get the default HTML output
crul <svc IP>:80

# test 1


# create deployment nginx2
kubectl apply -f nginxdeploy.yaml
kubectl get deploy,pod

# add the container port information and rerun apply
# we can quickly scale up the deployment
kubectl scale deployment hello-deploy --replicas=20
kubectl get deployment
kubectl get endopints
kubectl delete svc nginxdeploy

# expose our deployment to the outside world
kubectl expose deployment hello-deploy --type=LoadBalancer
kubectl get svc 
# now open the browser and copy the port <node IP>:<svc port>

# we can change the image of our deployment by running the command or modify the manifest file
kubectl set image deployment/hello-deploy hello-pod=httpd:alpine
kubectl set image deployment/hello-deploy hello-pod=nginx

kubectl describe pods |grep Image
kubectl expose deploy hello-deploy --name=hello-svc --target-port=8080 --type=NodePort

# modify the line under spec/containers - image
kubectl scale deployment nginxdeploy --replicas=10
kubectl apply -f nginxdeploy --record
kubectl rollout status deploy nginxdeploy
kubectl get deployment 
kubectl rollout history deployment nginxdeploy
kubectl describe pod nginxdeploy-6c74fcdfff-d9xbr | grep Image:

kubectl rollout history deployment nginxdeploy --revision=5
kubectl rollout undo deployment nginxdeploy --to-revision=4
kubectl scale deployment nginxdeploy --replicas=0
kubectl get pod
kubectl scale deployment nginxdeploy --replicas=3


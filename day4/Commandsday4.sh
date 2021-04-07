#alias alias alias = speed less wasting time

# for lab we can add our aliases to our bash profile 
vi ~/.bashrc


alias k=kubectl
alias kgp="kubectl get pods"
alias kgn="k get nodes"
alias kgd="k get deploy"
alias kd="k describe"
alias ka="k apply -f"





# svc.yml - services definition file


apiVersion: v1
kind: Service
metadata:
  name: hello-svc
spec:
  ports:
  - port: 8080
  selector:
    app: hello-world # Label selector

# Service is looking for Pods with the label `app=hello-world`
# deploy.yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-deploy
spec:
  replicas: 10
  selector:
    matchLabels:
      app: hello-world
  template:
    metadata:
      labels:
        app: hello-world # Pod labels The label matches the Service's label selector
    spec:
      containers:
      - name: hello-ctr
        image: szumigalskis/tamday:first
        ports:
        - containerPort: 8080


# command to expose the deployment
kubectl expose deployment hello-deploy --name=hello-svc --target-port=8080 --type=NodePort 
kubectl set image deployment/hello-deploy hello-ctr=szumigalskis/tamday:first




# end


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




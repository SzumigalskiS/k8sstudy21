# installing kubernetes on ubuntu
# change to run commands as root
sudo -i

# ubuntu update command
apt-get update

# installing the https transport protocol
apt-get install -y apt-transport-https

# adding kubernetes certificates to 
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

# adding kubernetes source
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

# rerun update command to refresh the source list
apt-get update

# disable the swap on the ubuntu, swap running can cause kubernetes services to not start
swapoff -a

# installing kubernetes and docker
apt-get update && sudo apt-get install -y   apt-transport-https ca-certificates curl software-properties-common gnupg2
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key --keyring /etc/apt/trusted.gpg.d/docker.gpg add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update && sudo apt-get install -y containerd.io=1.2.13-2 docker-ce=5:19.03.11~3-0~ubuntu-$(lsb_release -cs) docker-ce-cli=5:19.03.11~3-0~ubuntu-$(lsb_release -cs)
apt-get install -y kubectl kubelet kubernetes-cni kubeadm

# We can download the kubernetes images before the cluster creation
kubeadm config images pull

kubeadm init --pod-network-cidr=10.244.0.0/16  | tee $HOME/master.out

# exit sudo and run
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# check nodes 
kubectl get nodes

# check what pods are created

kubectl get pods --all-namespaces

# install networking for kubernetes cluster
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml


# learn how and create alias for your command to help you speed up work
alias k=kubectl
alias kgp="kubectl get pods"
alias kgn="k get nodes"
alias kgd="k get deploy"
alias kd="k describe"
alias ka="k apply -f"





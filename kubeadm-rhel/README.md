# Kubeadm-RHEL9
## **Step 1** - Configure Network (Control-Plane, Worker)
### Set Static IP for the Node
```bash
INTERFACE=$(sudo nmcli connection show | grep ethernet | awk '{print $1}')
ADDRESS=$(sudo nmcli -t -f IP4.ADDRESS device show "$INTERFACE" | awk -F ':' '{print $2}')
GATEWAY=$(sudo nmcli -t -f IP4.GATEWAY device show "$INTERFACE" | awk -F ':' '{print $2}')
sudo nmcli connection modify "$INTERFACE" ipv4.addresses "$ADDRESS"
sudo nmcli connection modify "$INTERFACE" ipv4.gateway "$GATEWAY"
sudo nmcli connection modify "$INTERFACE" ipv4.dns "8.8.8.8 8.8.4.4"
sudo nmcli connection modify "$INTERFACE" ipv4.method manual
sudo nmcli connection up "$INTERFACE"
```
### Enable IPv4 Forwarding
```bash
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system
sysctl net.ipv4.ip_forward
```
## **Step 2** - Install Containerd (Control-Plane, Worker)
### Install Containerd
```bash
sudo wget -q --https-only --timestamping --show-progress -e dotbytes=1M https://github.com/containerd/containerd/releases/download/v1.7.20/containerd-1.7.20-linux-amd64.tar.gz

sudo wget -q --https-only --timestamping --show-progress -e dotbytes=30 https://raw.githubusercontent.com/containerd/containerd/main/containerd.service

sudo tar Cxzvf /usr/local containerd-1.7.20-linux-amd64.tar.gz > /dev/null

if ls /usr/local/lib/systemd/system/ > /dev/null 2>&1; then
  echo "Directory /usr/local/lib/systemd/system/ exists"
else
  sudo mkdir -p /usr/local/lib/systemd/system/
  echo "Directory '/usr/local/lib/systemd/system/' created"
fi

sudo mv containerd.service /usr/local/lib/systemd/system/
sudo restorecon /usr/local/lib/systemd/system/containerd.service

if ls /etc/containerd > /dev/null 2>&1; then
  echo "Directory exists"
else
  sudo mkdir -p /etc/containerd
  echo "Directory '/etc/containerd' created"
fi

containerd config default | sudo tee /etc/containerd/config.toml > /dev/null
sudo sed -i 's/ SystemdCgroup = false/ SystemdCgroup = true/' /etc/containerd/config.toml

sudo systemctl daemon-reload
sudo systemctl enable --now containerd
```
### Install Runc
```bash
sudo wget -q --https-only --timestamping --show-progress -e dotbytes=250K https://github.com/opencontainers/runc/releases/download/v1.1.13/runc.amd64

sudo install -m 755 runc.amd64 /usr/local/sbin/runc
```
### Install CNI Plugin
```bash
sudo wget -q --https-only --timestamping --show-progress -e dotbytes=1M https://github.com/containernetworking/plugins/releases/download/v1.5.1/cni-plugins-linux-amd64-v1.5.1.tgz

sudo mkdir -p /opt/cni/bin
sudo tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v1.5.1.tgz > /dev/null
sudo chown root:root /opt/cni/bin

sudo rm containerd-1.7.20-linux-amd64.tar.gz runc.amd64 cni-plugins-linux-amd64-v1.5.1.tgz
```
## **Step 3** - Setup Kubernetes (Control-Plane, Worker)
### Disable Swap
```bash
sudo sed -i.bak '/swap/s/^/#/' /etc/fstab
sudo swapoff -a
```
### Disable SELinux
```bash
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
```
### Add Kubernetes YUM Repository
```bash
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.32/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.32/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF
```
### Install Kubelet, Kubeadm, and Kubectl
```bash
sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
```
### Enable Kubelet Service
```bash
sudo systemctl enable --now kubelet
```
**Note:** The kubelet is now restarting every few seconds, as it waits in a crashloop for kubeadm to tell it what to do.

## **Step 4** - Allow Required Ports (Control-Plane, Worker)
### Control-Plane Ports
```bash
sudo firewall-cmd --add-port=6443/tcp --add-port=2379-2380/tcp --add-port=10250/tcp --add-port=10259/tcp --add-port=10257/tcp --add-port=10256/tcp --add-port=30000-32767/tcp --add-port=8472/udp --add-port=53/udp --add-port=53/tcp --add-port=4240/tcp --permanent

sudo firewall-cmd --reload
```
### Worker Node Ports
```bash
sudo firewall-cmd --add-port=10250/tcp --add-port=10256/tcp --add-port=30000-32767/tcp --add-port=8472/udp --add-port=53/udp --add-port=53/tcp --add-port=4240/tcp --permanent

sudo firewall-cmd --reload
```
**Important:** Ports 4240 and 8472 are essential for Cilium. Depending on the Container Network Interface (CNI) in use, adjustments to these ports may be necessary.

## **Step 5** - Create Kubernetes Cluster (Control-Plane)
### Initialize Control-Plane
```bash
IP=$(echo "$ADDRESS" | awk -F '/' '{print $1}')
sudo kubeadm config images pull
sudo kubeadm init --apiserver-advertise-address=$IP --pod-network-cidr=10.244.0.0/16
```
### Configure Kubectl
```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
### Remove Control-Plane Taint
```bash
kubectl taint nodes $(hostname) node-role.kubernetes.io/control-plane:NoSchedule-
```
## **Step 6** - Deploy Helm Charts (Control-Plane)
### Install Helm
```bash
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```
### Add Helm Repositories
```bash
helm repo add cilium https://helm.cilium.io/
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm repo update
```
### Install Helm Charts
```bash
helm install cilium cilium/cilium --set ipam.operator.clusterPoolIPv4PodCIDRList='10.244.0.0/16' -n kube-system

helm install metrics-server metrics-server/metrics-server --set replicas=3  --set args[0]='--kubelet-insecure-tls' -n kube-system
```
## **Step 7** - Join Worker Node to Cluster (Worker)
### Join Worker
```bash
sudo kubeadm join 192.168.176.50:6443 --token woags4.ssgf7r270hu6ae7y --discovery-token-ca-cert-hash sha256:77441a4fb4f63425a38ace269c212432dd38d1bfcdbe168a36018608c3c76ee5
```
**Important:** Replace the kubeadm join command with the one generated with `kubeadm init`, or generate a new one with `kubeadm token create --print-join-command` in the Control-Plane.
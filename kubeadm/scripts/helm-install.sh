#!/bin/bash

echo "#########################################################################################"
echo "#                     ⏳ STEP 6: INSTALLING HELM AND HELM CHARTS 🚀                     #"
echo "#########################################################################################"

source /vagrant/scripts/common.sh

retries "curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash" "Installing helm failed."

retries "helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx" "Failed to add Ingress-Nginx helm repository."
retries "helm repo add prometheus-community https://prometheus-community.github.io/helm-charts" "Failed to add Prometheus-Community helm repository."
retries "helm repo add argo https://argoproj.github.io/argo-helm" "Failed to add Argo helm repository."
retries "helm repo add sealed-secrets https://bitnami-labs.github.io/sealed-secrets" "Failed to add Sealed-Secrets helm repository."
retries "helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/" "Failed to add Metrics-Server helm repository."
retries "helm repo add cilium https://helm.cilium.io/" "Failed to add Cilium helm repository."
retries "helm repo add metallb https://metallb.github.io/metallb" "Failed to add MetalLB helm repository."

retries "helm repo update" "Failed to update helm repository."

retries "helm install cilium cilium/cilium --set ipam.operator.clusterPoolIPv4PodCIDRList='10.244.0.0/16' -n kube-system" "Failed to install Cilium helm chart."
retries "helm install metallb metallb/metallb -n metallb-system --create-namespace" "Installing MetalLB helm chart."
retries "helm install metrics-server metrics-server/metrics-server --set replicas=3  --set args[0]='--kubelet-insecure-tls' -n kube-system" "Failed to install Metrics-Server helm chart."
retries "helm install ingress-nginx ingress-nginx/ingress-nginx -n ingress-nginx --create-namespace" "Failed to install Ingress-Nginx helm chart."
retries "helm install prom-stack prometheus-community/kube-prometheus-stack -n monitoring --create-namespace" "Failed to install Kube-Prometheus-Stack helm chart."
retries "helm install argo-cd argo/argo-cd -n argocd --create-namespace" "Failed to install ArgoCD helm chart."
retries "helm install sealed-secrets -n kube-system --set-string fullnameOverride=sealed-secrets-controller sealed-secrets/sealed-secrets" "Failed to install Sealed-Secrets helm chart."

retries kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/v0.0.29/deploy/local-path-storage.yaml "Failed to install Local-Path-Storage."
kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

echo "#########################################################################################"
echo "#                  ✅ HELM AND HELM CHARTS INSTALLED SUCCESSFULLY! 🎉                   #"
echo "#########################################################################################"
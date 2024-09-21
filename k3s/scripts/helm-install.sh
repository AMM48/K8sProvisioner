#!/bin/bash

echo "#########################################################################################"
echo "#                     ⏳ STEP 4: INSTALLING HELM AND HELM CHARTS 🚀                     #"
echo "#########################################################################################"

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add argo https://argoproj.github.io/argo-helm
helm repo add sealed-secrets https://bitnami-labs.github.io/sealed-secrets
helm repo add cilium https://helm.cilium.io/

helm repo update

helm install cilium cilium/cilium --set ipam.operator.clusterPoolIPv4PodCIDRList="10.42.0.0/16" -n kube-system
helm install ingress-nginx ingress-nginx/ingress-nginx -n ingress-nginx --create-namespace
helm install prom-stack prometheus-community/kube-prometheus-stack -n monitoring --create-namespace
helm install argo-cd argo/argo-cd -n argocd --create-namespace
helm install sealed-secrets -n kube-system --set-string fullnameOverride=sealed-secrets-controller sealed-secrets/sealed-secrets

echo "#########################################################################################"
echo "#                  ✅ HELM AND HELM CHARTS INSTALLED SUCCESSFULLY! 🎉                   #"
echo "#########################################################################################"
#!/bin/bash

echo "⏳🚀 Step 4: Installing helm and helm charts..."

echo "⏳🚀 Installing helm..."
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
echo "✅ Done!"

echo "⏳🚀 Adding Ingress-nginx helm chart repository..."
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

echo "⏳🚀 Adding Prometheus-community helm chart repository..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
echo "✅ Done!"

echo "⏳🚀 Adding Argocd helm chart repository..."
helm repo add argo https://argoproj.github.io/argo-helm
echo "✅ Done!"

echo "⏳🚀 Adding Sealed-secrets helm chart repository..."
helm repo add sealed-secrets https://bitnami-labs.github.io/sealed-secrets
echo "✅ Done!"

echo "⏳🚀 Adding Cilium helm chart repository..."
helm repo add cilium https://helm.cilium.io/
echo "✅ Done!"

echo "⏳🚀 Updating local chart repository..."
helm repo update
echo "✅ Done!"

echo "⏳🚀 Installing Cilium helm chart..."
helm install cilium cilium/cilium --set ipam.operator.clusterPoolIPv4PodCIDRList="10.42.0.0/16" -n kube-system
echo "✅ Done!"

echo "⏳🚀 Installing Ingress-nginx helm chart..."
helm install ingress-nginx ingress-nginx/ingress-nginx -n ingress-nginx --create-namespace
echo "✅ Done!"

echo "⏳🚀 Installing Prometheus-community helm chart..."
helm install prom-stack prometheus-community/kube-prometheus-stack -n monitoring --create-namespace
echo "✅ Done!"

echo "⏳🚀 Installing Argocd helm chart..."
helm install argo-cd argo/argo-cd -n argocd --create-namespace
echo "✅ Done!"

echo "⏳🚀 Installing Sealed-secrets helm chart..."
helm install sealed-secrets -n kube-system --set-string fullnameOverride=sealed-secrets-controller sealed-secrets/sealed-secrets
echo "✅ Done!"

echo "✅ Installing helm and helm charts Complete!"
echo "_____________________________________________________________"
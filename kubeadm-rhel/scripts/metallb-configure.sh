#!/bin/bash

echo "#########################################################################################"
echo "#                           ⏳ STEP 8: CONFIGURING METALLB 🚀                           #"
echo "#########################################################################################"

echo "apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: my-pool
  namespace: metallb-system
spec:
  addresses:
  - 192.168.176.2-192.168.176.20" > pool.yaml

echo "apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: advertisement
  namespace: metallb-system
spec:
  ipAddressPools:
  - my-pool" > advertisement.yaml

kubectl wait --namespace metallb-system --for=condition=ready pod -l app.kubernetes.io/name=metallb --timeout=5m

kubectl apply -f pool.yaml -f advertisement.yaml
rm *.yaml
echo "##########################################################################################"
echo "#                         ✅ METALLB CONFIGURED SUCCESSFULLY! 🎉                         #"
echo "##########################################################################################"
#!/bin/bash
echo "🚀 Start deploying cluster..."
echo ""
sudo kubectl kustomize --enable-helm ../overlays/local/ | sudo KUBECONFIG=/etc/rancher/k3s/k3s.yaml kapp deploy -a antiginx-cluster -f - -y
echo ""
echo "✅ Implementation completed! Check the pod and svc status:"
echo ""
echo "--- ALL PODS ---"
sudo kubectl get pods -A
echo ""
echo "--- ALL SVC ---"
sudo kubectl get svc -A

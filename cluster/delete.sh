#!/bin/bash
echo "🔥 Start clearing the cluster..."
echo ""
sudo KUBECONFIG=/etc/rancher/k3s/k3s.yaml kapp delete -a antiginx-cluster -y
sudo kubectl delete namespace monitoring antiginx data test-app --ignore-not-found
echo ""
echo "✅ Everything deleted! The cluster is completely clean."

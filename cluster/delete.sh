#!/bin/bash
set -euo pipefail

 ENV="${1:-}"

 if [[ -z "$ENV" ]]; then
    echo "❌ Use: ./apply.sh <dev|prod>"
    exit 1
fi

if [[ ! -d "../overlays/${ENV}" ]]; then
    echo "❌ Directory ../overlays/${ENV} does not exist!"
    exit 1
fi

if [[ "$ENV" == "prod" ]]; then
   read -rp "⚠️ Delete on PRODUCTION. Type 'yes' to confirm: " c
   [[ "$c" == "yes" ]] || { echo "Cancel."; exit 1; }
fi

echo "🔥 Start clearing the cluster..."
echo ""

sudo KUBECONFIG=/etc/rancher/k3s/k3s.yaml kapp delete -a "antiginx-${ENV}" -y
sudo kubectl delete namespace monitoring antiginx data scan-targets --ignore-not-found

echo ""
echo "✅ Everything deleted! The cluster is completely clean."

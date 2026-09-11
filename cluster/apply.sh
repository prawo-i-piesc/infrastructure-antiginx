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
  read -rp "⚠️ Deploy on PRODUCTION. Type 'yes' to confirm: " c
  [[ "$c" == "yes" ]] || { echo "Cancel."; exit 1; }
fi
 
echo "🚀 Deploying overlay: ${ENV}"
echo ""
sudo kubectl kustomize --enable-helm "../overlays/${ENV}/" \
  | sudo KUBECONFIG=/etc/rancher/k3s/k3s.yaml kapp deploy -a "antiginx-${ENV}" -f - -y

echo ""
echo "--- ALL PODS ---"
sudo kubectl get pods -A
echo ""
echo "--- ALL SVC ---"
sudo kubectl get svc -A

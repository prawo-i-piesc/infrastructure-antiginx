<div align="center">
 
# `Antiginx Infrastructure`
 
This repository contains the Kubernetes infrastructure manifests for the **Antiginx** project. It utilizes **Kustomize** to manage base configurations and environment-specific overrides, enabling a structured and scalable GitOps workflow.
 
[![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=flat-square&logo=kubernetes&logoColor=white)](https://kubernetes.io/)
[![Kustomize](https://img.shields.io/badge/Kustomize-000000?style=flat-square&logo=kubernetes&logoColor=white)](https://kustomize.io/)
[![License: MIT](https://img.shields.io/badge/License-MIT-A3BE8C?style=flat-square)](LICENSE)
 
</div>
 
<br>
 
### 📁 Repository Structure
 
The repository is organized following Kubernetes and Kustomize best practices:
 
*   **`apps/`**: Base manifests (`Deployment`, `Service`, `PVC`, `Namespace`) that are deployed to **every** environment unchanged:
    *   `antiginx/`: Core microservices including `frontend`, `backend`, and `engine`.
    *   `data/`: Persistent stateful services and message brokers like `postgres` and `rabbitmq`.
    *   `monitoring/`: Observability stack based on the `kube-prometheus-stack` Helm chart.
*   **`addons/`**: Optional, self-contained features enabled per environment. Currently used by `dev` only:
    *   `pgadmin/`: Web UI for `postgres`, deployed into the `data` namespace.
    *   `rabbitmq-management/`: `LoadBalancer` service exposing the RabbitMQ management panel.
    *   `scan-targets/`: Intentionally vulnerable targets such as OWASP `juice-shop`, `webgoat` and `dvwa`.
*   **`overlays/`**: Environment-specific configuration, image tags, patches and secrets. Defined overlays are `dev` and `prod`.
*   **`cluster/`**: Deployment scripts (`apply.sh`, `delete.sh`) wrapping `kustomize` and `kapp`.
*   **`.github/`**: CI/CD automation, including GitHub Actions workflows (like `pr-automation.yml`), Dependabot setup, and repository configurations.
 
<br>
 
### 🚀 Getting Started
 
#### Prerequisites
Before deploying, ensure you have the following installed:
*   A running Kubernetes cluster (this setup targets **k3s**, but any cluster works).
*   `kubectl` command-line tool configured to communicate with your cluster.
*   `kapp` for declarative deployments and diffing.
*   `helm` — required because the monitoring stack is rendered with `--enable-helm`.
 
#### Secrets Management
Secrets live in the overlay, so each environment holds its own values. \
Real secret files are **git-ignored**; only `*.example.yaml` templates are committed.
 
Before the first deployment, create the actual files from the templates:
 
```bash
for f in overlays/dev/secrets/*/*.example.yaml; do cp "$f" "${f%.example.yaml}.yaml"; done
```
 
Then fill in every `<PLACEHOLDER>` value. \
**Important:** Do **not** commit actual passwords or keys to version control.
 
#### Deployment
 
Deployments are handled by `apply.sh`, which renders the selected overlay and applies it with `kapp`.
 
```bash
cd cluster
./apply.sh dev     # or: ./apply.sh prod
```
 
Deploying to `prod` requires an explicit confirmation prompt.
 
To tear an environment down:
 
```bash
./delete.sh dev
```
 
<br>
 
---
 
<div align="center">
 
### 📜 Licence 📜
 
The project is available under license [MIT](../LICENSE).
 
Copyright © 2026 [Prawo i Pięść](https://github.com/prawo-i-piesc)
 
</div>

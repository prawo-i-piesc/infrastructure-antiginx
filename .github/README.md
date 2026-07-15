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

*   **`apps/`**: Contains the base Kubernetes manifests (`Deployment`, `Service`, `PVC`, `Namespace`) separated into logical domains:
    *   `antiginx/`: Core microservices including `frontend`, `backend`, and `engine`.
    *   `data/`: Persistent stateful services and message brokers like `postgres` and `rabbitmq`.
    *   `test-app/`: Security and testing targets, such as OWASP `juice-shop`.
*   **`overlays/`**: Contains environment-specific configurations and patches. Currently defined overlays include `local` and `production`.
*   **`clusters/`**: Holds cluster-level configurations (e.g., `claster_soon`).
*   **`.github/`**: CI/CD automation, including GitHub Actions workflows (like `pr-automation.yml`), Dependabot setup, and repository configurations.

<br>

### 🚀 Getting Started

#### Prerequisites
Before deploying, ensure you have the following installed:
*   A running Kubernetes cluster (e.g., Minikube, kind, or a managed cloud cluster).
*   `kubectl` command-line tool configured to communicate with your cluster.

#### Secrets Management
This repository includes example secret templates (e.g., `antiginx-secret.example.yaml`, `data-secret.example.yaml`). \
**Important:** You must create the actual Kubernetes Secrets in your cluster using these templates before deploying. Do **not** commit actual passwords or keys to version control.

#### Deployment

To deploy the infrastructure, use `kubectl apply` with the `-k` flag to target a specific overlay. 

For example, to deploy the local development environment:

```bash
kubectl apply -k overlays/local
```

<br>

---

<div align="center">

### 📜 Licence 📜

The project is available under license [MIT](../LICENSE).

Copyright © 2026 [Prawo i Pięść](https://github.com/prawo-i-piesc)

</div>

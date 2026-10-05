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
    *   `ingress/`: Configuration of the k3s-bundled Traefik — Let's Encrypt certificates via the OVH DNS-01 challenge.
*   **`addons/`**: Optional, self-contained features enabled per environment. Currently used by `dev` only:
    *   `pgadmin/`: Web UI for `postgres`, deployed into the `data` namespace.
    *   `rabbitmq-management/`: `Ingress` exposing the RabbitMQ management panel.
    *   `scan-targets/`: Intentionally vulnerable targets such as OWASP `juice-shop`, `webgoat` and `dvwa`.
*   **`overlays/`**: Environment-specific configuration, image tags, patches and secrets. Defined overlays are `dev` and `prod`.
*   **`cluster/`**: Deployment scripts (`apply.sh`, `delete.sh`) wrapping `kustomize` and `kapp`.
*   **`.github/`**: CI/CD automation, including GitHub Actions workflows (like `pr-automation.yml`), Dependabot setup, and repository configurations.
 
<br>
 
### 🚀 Getting Started
 
#### Prerequisites
Before deploying, ensure you have the following installed:
*   A running **k3s** cluster with its bundled Traefik enabled (it serves every `Ingress` and issues the certificates).
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

#### Domains & HTTPS

Nothing is exposed to the internet. Every service is a `ClusterIP` behind an `Ingress`, reachable only from the team's WireGuard network. \
The hostnames below resolve in public DNS (zone `karwowski.dev` at OVH) to the node's WireGuard address. \
Traefik obtains Let's Encrypt certificates through the **DNS-01** challenge, so the node never has to be reachable from outside.

| Environment | Service | Hostname |
| --- | --- | --- |
| `prod` | Frontend | `antiginx.karwowski.dev` |
| `prod` | Grafana | `grafana.antiginx.karwowski.dev` |
| `dev` | Frontend | `dev.antiginx.karwowski.dev` |
| `dev` | Grafana | `grafana.dev.antiginx.karwowski.dev` |
| `dev` | pgAdmin | `pgadmin.dev.antiginx.karwowski.dev` |
| `dev` | RabbitMQ | `rabbitmq.dev.antiginx.karwowski.dev` |

Production hostnames live in the base manifests; `overlays/dev/patches/` swaps them for the `dev` ones.

One-time setup:

1. **OVH API keys** — create them at `https://eu.api.ovh.com/createToken/` with `GET`, `POST`, `PUT` and `DELETE` on `/domain/zone/karwowski.dev/*`, then put them in `secrets/traefik/traefik-acme-secrets.yaml`.
2. **DNS records** — an `A` record per hostname above, pointing at the node's WireGuard address.
3. **App secrets** — `PUBLIC_BASE_URL` set to the frontend hostname (`https://…`), `COOKIE_SECURE` and `TRUST_PROXY_HEADERS` set to `"true"`.
4. **OAuth callbacks** — `https://<frontend hostname>/api/auth/oauth/google/callback` in the Google client and `https://<frontend hostname>/api/auth/oauth/github/callback` in one GitHub OAuth App per environment.

Certificates are kept in `/data/acme.json` on Traefik's persistent volume. Check issuance with:

```bash
sudo kubectl -n kube-system logs deploy/traefik | grep -i acme
```
 
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

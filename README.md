# Task Management Application Helm & FluxCD GitOps

A production-oriented GitOps deployment implementation for a cloud-native Task Management Application using Kubernetes, Helm, FluxCD, Istio, cert-manager, MongoDB, and Redis.

This repository demonstrates modern Kubernetes application delivery practices, including Helm-based packaging, multi-environment configuration management, GitOps workflows, automated image promotion, TLS automation, service networking, and stateful workload deployment.

The deployment stack includes:

* Task Management Application
* MongoDB StatefulSet
* Redis Session Store
* cert-manager Certificate
* Istio Gateway
* Istio VirtualService
* FluxCD GitOps Deployment

---

## Highlights

* Helm-based application packaging
* FluxCD GitOps deployment workflow
* Environment-specific configuration management
* MongoDB StatefulSet with persistent storage
* Redis session management
* cert-manager TLS automation
* Istio ingress and traffic routing
* Security-focused container configuration
* Reusable Helm helpers and templating
* Automated image promotion through GitHub Actions

---

## Deployment Stack

* Kubernetes
* Helm
* FluxCD
* Istio
* cert-manager
* MongoDB
* Redis
* GitHub Actions
* GitHub Container Registry (GHCR)

---

## Related Repositories

### Application Repository

The application source code is maintained separately.

Repository:

```text
github.com/crchiran/golang-task-management-app
```

Responsibilities:

* Go application source code
* Dockerfile
* Unit tests
* Integration tests
* GitHub Actions CI/CD pipeline
* Container image builds
* Security scanning with Trivy
* Publishing container images to GitHub Container Registry (GHCR)
* Updating deployment image versions in the GitOps repository

---

### GitOps Deployment Repository

This repository contains:

* Helm chart
* Kubernetes manifests
* Helm templates
* FluxCD HelmRelease resources
* FluxCD Kustomization resources
* Namespace management
* Environment-specific values
* Deployment configuration
* GitOps workflow

Repository Structure:

```text
.
├── Chart.yaml
├── README.md
├── values.yaml
│
├── clusters
│   ├── dev
│   │   ├── kustomization.yaml
│   │   └── task-management
│   │       ├── helmrelease.yaml
│   │       ├── kustomization.yaml
│   │       ├── namespace.yaml
│   │       └── values.yaml
│   │
│   └── prod
│       ├── kustomization.yaml
│       └── task-management
│           ├── helmrelease.yaml
│           ├── kustomization.yaml
│           ├── namespace.yaml
│           └── values.yaml
│
├── templates
│   ├── _helpers.tpl
│   ├── app-configmap.yaml
│   ├── app-deployment.yaml
│   ├── app-secret.yaml
│   ├── app-service.yaml
│   ├── certificate.yaml
│   ├── gateway.yaml
│   ├── mongodb-headless-service.yaml
│   ├── mongodb-init-configmap.yaml
│   ├── mongodb-secret.yaml
│   ├── mongodb-service.yaml
│   ├── mongodb-statefulset.yaml
│   ├── namespace.yaml
│   ├── redis-deployment.yaml
│   ├── redis-secret.yaml
│   ├── redis-service.yaml
│   └── virtualservice.yaml
│
└── values.yaml
```

---

## Deployment Workflow

```text
Developer
    │
    ▼
Application Repository
(golang-task-management-app)
    │
    ▼
GitHub Actions
    │
    ├── Go Format Validation
    ├── Go Vet
    ├── Unit Tests
    ├── Integration Tests
    ├── Trivy Source Scan
    ├── Docker Build
    ├── Trivy Image Scan
    └── Push Image to GHCR
    │
    ▼
Update Environment Values
(dev/prod image tag)
    │
    ▼
GitOps Repository
    │
    ▼
FluxCD
    │
    ▼
Kubernetes Cluster
```

---

## Architecture

```text
                      Internet
                          │
                          ▼
                   Istio Gateway
                          │
                          ▼
                   VirtualService
                          │
                          ▼
               Task Management App
                          │
              ┌───────────┴───────────┐
              ▼                       ▼
           MongoDB                 Redis
        (StatefulSet)         (Deployment)
```

---

## Components

### Task Management Application

The primary application workload deployed as a Kubernetes Deployment.

Features:

* Rolling updates
* Health probes
* ConfigMap-based configuration
* Secret-based credential management
* Resource requests and limits
* Security-focused container configuration

Files:

```text
templates/app-configmap.yaml
templates/app-secret.yaml
templates/app-deployment.yaml
templates/app-service.yaml
```

---

### MongoDB

MongoDB is deployed as a StatefulSet with persistent storage.

Features:

* Persistent Volume Claims
* Stable network identity
* Headless Service
* Application user initialization
* Authentication support

Files:

```text
templates/mongodb-secret.yaml
templates/mongodb-init-configmap.yaml
templates/mongodb-statefulset.yaml
templates/mongodb-service.yaml
templates/mongodb-headless-service.yaml
```

---

### Redis

Redis is deployed as a Deployment and used for session storage.

Features:

* Password authentication
* Memory management
* LRU eviction policy
* Internal ClusterIP service

Files:

```text
templates/redis-secret.yaml
templates/redis-deployment.yaml
templates/redis-service.yaml
```

---

### TLS Certificate Management

TLS certificates are managed through cert-manager.

Features:

* Automated certificate provisioning
* Automated certificate renewal
* ClusterIssuer integration

Files:

```text
templates/certificate.yaml
```

---

### Istio Traffic Management

Application traffic is managed through Istio Gateway and VirtualService resources.

Features:

* HTTPS termination
* Host-based routing
* Service traffic management

Files:

```text
templates/gateway.yaml
templates/virtualservice.yaml
```

---

## Technologies Used

* Helm
* FluxCD
* Kubernetes
* MongoDB
* Redis
* Istio
* cert-manager
* ConfigMaps
* Secrets
* Deployments
* StatefulSets
* Persistent Volumes
* TLS Certificates

---

## Configuration

Base chart configuration is managed through:

```text
values.yaml
```

Example:

```yaml
app:
  replicas: 2

mongodb:
  replicas: 1

redis:
  replicas: 1
```

---

## Environment Configuration

Environment-specific overrides are maintained separately.

```text
clusters/dev/task-management/values.yaml
clusters/prod/task-management/values.yaml
```

This allows independent configuration of:

* Container image tags
* Replica counts
* Resource requests and limits
* Domain names
* TLS settings
* Environment variables
* Certificate issuers

---

## Validate the Chart

Validate chart syntax:

```bash
helm lint .
```

Render manifests locally:

```bash
helm template task-management .
```

Render manifests using production values:

```bash
helm template task-management . \
  -f values.yaml \
  -f clusters/prod/task-management/values.yaml
```

Render manifests using development values:

```bash
helm template task-management . \
  -f values.yaml \
  -f clusters/dev/task-management/values.yaml
```

Render manifests to a file:

```bash
helm template task-management . > manifests.yaml
```

---

## Local Installation

Install directly using Helm:

```bash
helm upgrade --install task-management . \
  --namespace task-management \
  --create-namespace
```

---

## FluxCD Deployment

Environment-specific resources are managed through FluxCD Kustomizations and HelmRelease resources.

Development Environment:

```text
clusters/dev
├── kustomization.yaml
└── task-management
    ├── namespace.yaml
    ├── kustomization.yaml
    ├── helmrelease.yaml
    └── values.yaml
```

Production Environment:

```text
clusters/prod
├── kustomization.yaml
└── task-management
    ├── namespace.yaml
    ├── kustomization.yaml
    ├── helmrelease.yaml
    └── values.yaml
```

FluxCD continuously monitors the Git repository and reconciles the desired state into the Kubernetes cluster.

Example bootstrap:

```bash
flux bootstrap github \
  --owner=<github-user> \
  --repository=<gitops-repository> \
  --branch=main \
  --path=clusters/prod \
  --personal=true
```

---

## Verification

Verify deployed resources:

```bash
kubectl get all -n task-management
```

Verify StatefulSets:

```bash
kubectl get sts -n task-management
```

Verify Persistent Volume Claims:

```bash
kubectl get pvc -n task-management
```

Verify Services:

```bash
kubectl get svc -n task-management
```

Verify Certificates:

```bash
kubectl get certificate -A
```

Verify Gateways:

```bash
kubectl get gateway -A
```

Verify VirtualServices:

```bash
kubectl get virtualservice -A
```

Verify FluxCD resources:

```bash
flux get kustomizations -A
flux get helmreleases -A
```

---

## Upgrade

Upgrade the release manually:

```bash
helm upgrade task-management . \
  --namespace task-management
```

View release history:

```bash
helm history task-management \
  --namespace task-management
```

Rollback if required:

```bash
helm rollback task-management <revision> \
  --namespace task-management
```

---

## Uninstall

Remove the Helm release:

```bash
helm uninstall task-management \
  --namespace task-management
```

Remove persistent storage if required:

```bash
kubectl delete pvc -n task-management --all
```

---

## Domain Configuration

> **Note**
>
> This repository uses `hudai.xyz` domains throughout the examples and default configuration because they are used in the author's environment.
>
> Before deploying, update all domain-related values to match your own DNS records, certificates, and ingress configuration.

Example:

```yaml
ingress:
  host: your-domain.com
```

Ensure that:

* DNS records point to your Kubernetes ingress endpoint
* TLS certificates are issued for your domain
* Gateway and VirtualService resources reference your hostnames
* cert-manager ClusterIssuer is configured for your environment

---

## Project Goals

This repository demonstrates how to deploy and manage a cloud-native application using modern Kubernetes and GitOps practices.

Key areas covered:

* Helm chart development
* FluxCD GitOps workflows
* Multi-environment deployments
* Stateful workload management
* TLS certificate automation
* Service networking with Istio
* Automated image promotion
* Kubernetes application lifecycle management
* Environment-specific configuration management

---

## License

MIT

---

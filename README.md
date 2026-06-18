# Task Management Application Helm & FluxCD GitOps

A production-oriented GitOps deployment implementation for a cloud-native Task Management Application using Kubernetes, Helm, FluxCD, Istio, cert-manager, MongoDB, and Redis.

This repository demonstrates modern Kubernetes application delivery practices, including Helm-based packaging, multi-environment configuration management, GitOps workflows, automated image promotion, TLS automation, service networking, and stateful workload deployment.

The deployment includes:

* Task Management Application
* MongoDB StatefulSet
* Redis Session Store
* cert-manager Certificate
* Istio Gateway
* Istio VirtualService
* FluxCD HelmRelease Resources

---

## Highlights

* Helm-based application packaging
* FluxCD GitOps deployment workflow
* Kubernetes-native configuration management
* MongoDB StatefulSet with persistent storage
* Redis session management
* cert-manager TLS automation
* Istio ingress and traffic routing
* Security-focused container configuration
* Reusable Helm helpers and templating
* Environment-specific configuration management
* Automated image promotion through GitOps

---

## GitOps Deployment

This repository is designed to support GitOps-based deployments using FluxCD and HelmRelease resources.

Environment-specific configurations are separated into dedicated directories:

```text
clusters/
├── dev/
└── prod/
```

Each environment contains:

* HelmRelease resource
* Environment-specific values
* Independent image versions
* Environment-specific application configuration

This enables the same Helm chart to be deployed consistently across multiple environments while maintaining isolated configuration.

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

## Repository Structure

```text
.
├── Chart.yaml
├── README.md
├── values.yaml
│
├── clusters
│   ├── dev
│   │   └── task-management
│   │       ├── helmrelease.yaml
│   │       └── values.yaml
│   │
│   └── prod
│       └── task-management
│           ├── helmrelease.yaml
│           └── values.yaml
│
└── templates
    ├── _helpers.tpl
    ├── namespace.yaml
    │
    ├── app-configmap.yaml
    ├── app-secret.yaml
    ├── app-deployment.yaml
    ├── app-service.yaml
    │
    ├── mongodb-secret.yaml
    ├── mongodb-init-configmap.yaml
    ├── mongodb-statefulset.yaml
    ├── mongodb-service.yaml
    ├── mongodb-headless-service.yaml
    │
    ├── redis-secret.yaml
    ├── redis-deployment.yaml
    ├── redis-service.yaml
    │
    ├── certificate.yaml
    ├── gateway.yaml
    └── virtualservice.yaml
```

---

## Deployment Modes

This repository supports two deployment methods.

### Helm Deployment

Deploy directly using Helm:

```bash
helm upgrade --install task-management . \
  --namespace task-management \
  --create-namespace
```

### FluxCD GitOps Deployment

Deploy using FluxCD and HelmRelease resources:

```text
clusters/dev/task-management/
clusters/prod/task-management/
```

FluxCD continuously reconciles the desired state from Git into the Kubernetes cluster.

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

Example HelmRelease structure:

```text
clusters/dev/task-management/
├── helmrelease.yaml
└── values.yaml
```

FluxCD continuously monitors the Git repository and reconciles the desired state into the Kubernetes cluster.

Deployment workflow:

```text
Developer
    │
    ▼
GitHub Actions
    │
    ▼
Update values.yaml image tag
    │
    ▼
Git Repository
    │
    ▼
FluxCD
    │
    ▼
Kubernetes Cluster
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

---

## Upgrade

Upgrade the release:

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
> This project uses `hudai.xyz` domains throughout the examples and default configuration because they are used in the author's environment.
>
> Before deploying the application, update all domain-related values to match your own DNS records, certificates, and ingress configuration.

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

## Project Status

This project serves as both:

* A reusable Helm chart for Kubernetes application deployment
* A GitOps deployment example using FluxCD and HelmRelease resources

It demonstrates:

* Helm chart development
* Kubernetes application packaging
* Environment-specific configuration management
* GitOps deployment workflows
* FluxCD reconciliation
* Container image promotion through Git
* TLS certificate automation
* Istio traffic management

The repository is intended as a practical reference for building and operating cloud-native applications using Helm, FluxCD, Kubernetes, and GitOps principles.

---
# Task Management Application Helm Chart

A Helm chart for deploying a cloud-native Task Management Application on Kubernetes.

This project demonstrates how to package, configure, and deploy a complete application stack using Helm, including application services, databases, session storage, TLS certificate management, and Istio-based traffic routing.

The chart deploys:

* Task Management Application
* MongoDB StatefulSet
* Redis Session Store
* cert-manager Certificate
* Istio Gateway
* Istio VirtualService

---

## Highlights

* Helm-based application packaging
* Kubernetes-native configuration management
* MongoDB StatefulSet with persistent storage
* Redis session management
* cert-manager TLS automation
* Istio ingress and traffic routing
* Security-focused container configuration
* Reusable Helm helpers and templating
* Environment-specific configuration through values files

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
└── templates
    ├── _helpers.tpl
    │
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
* Kubernetes
* MongoDB
* Redis
* Istio
* cert-manager
* TLS Certificates
* ConfigMaps
* Secrets
* StatefulSets
* Deployments
* Persistent Volumes

---

## Configuration

All application configuration is managed through:

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

Validate the rendered manifests:

```bash
helm template task-management .
```

---

## Installation

Validate chart syntax:

```bash
helm lint .
```

Render manifests:

```bash
helm template task-management . \
  -n task-management
```

Install the chart:

```bash
helm upgrade --install task-management . \
  -n task-management \
  --create-namespace
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

Verify Certificate:

```bash
kubectl get certificate -n istio-system
```

Verify Gateway:

```bash
kubectl get gateway -n istio-system
```

Verify VirtualService:

```bash
kubectl get virtualservice -n task-management
```

---

## Upgrade

Upgrade the release after modifying templates or values:

```bash
helm upgrade task-management . \
  -n task-management
```

View release history:

```bash
helm history task-management \
  -n task-management
```

Rollback if required:

```bash
helm rollback task-management <revision> \
  -n task-management
```

---

## Uninstall

Remove the Helm release:

```bash
helm uninstall task-management \
  -n task-management
```

Remove persistent storage if required:

```bash
kubectl delete pvc -n task-management --all
```

---

## Project Status

This project is maintained as a reference Helm chart for deploying a cloud-native Task Management Application on Kubernetes.

It demonstrates application packaging, configuration management, persistent storage, service networking, TLS certificate automation, and Istio traffic routing using reusable Helm templates.

---

## Domain Configuration

> **Note**
>
> This chart uses `hudai.xyz` domains throughout the examples and default configuration because they are used in the author's environment.
>
> Before deploying the chart, update all domain-related values in `values.yaml` to match your own DNS records, TLS certificates, and ingress configuration.
>
> Example:
>
> ```yaml
> ingress:
>   host: your-domain.com
> ```
>
> Ensure that:
>
> * DNS records point to your Kubernetes ingress endpoint
> * TLS certificates are issued for your domain
> * Gateway and VirtualService resources reference your hostnames
> * cert-manager ClusterIssuer is configured for your environment


---

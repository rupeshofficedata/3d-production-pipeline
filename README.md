# 3D Production Pipeline (End-to-End)

## Role
Senior Cloud & DevOps Engineer

## Overview
SHAZAM is a production-grade, end-to-end 3D asset production pipeline that manages:
- Artist workflows (cleanup → UV → texturing)
- Structured ZIP-based delivery
- Automated validation
- QA approval and rejection loops
- Version-controlled storage
- GPU-based 360 rendering
- ASIN / image-based search
- Final asset publishing to product pages

This project demonstrates real-world DevOps ownership of a creative pipeline.

---

## End-to-End Workflow

1. 3D scan data (JPEG + OBJ) exists
2. Artist completes 3 production stages
3. Final ZIP uploaded to shazam
4. ZIP validated automatically
5. Assets unzipped and stored by ASIN
6. QA reviews GLB vs reference images
7. Approved versions promoted, old versions deleted
8. 360 renders generated from GLB
9. Search bot enables discovery
10. Assets displayed on product pages

---

## Tech Stack

- AWS (EKS, S3, IAM, ALB)
- Terraform (IaC)
- Kubernetes
- Docker
- Python
- Jenkins / GitHub Actions
- Prometheus & Grafana
- Linux
- Git

---


# Terraform – Infrastructure Layer

This folder creates all AWS resources required by SHAZAM.

Why Terraform?
- Infrastructure as code
- Repeatable
- Auditable
- Safe rollback

Why terraform-aws-modules?
- AWS best practices built-in
- Fewer mistakes
- Less maintenance

## Repository Structure

<details>
<summary>📂 3d-production-pipeline</summary>

├── 📄 README.md                # Master documentation  

<details>
<summary>📂 terraform — Infrastructure (AWS)</summary>

│   ├── 📄 backend.tf           # Remote state (S3)  
│   ├── 📄 providers.tf         # Provider configuration  
│   ├── 📄 versions.tf          # Provider versions  
│   ├── 📄 variables.tf         # Derclare the Variable (required)  
│   ├── 📂 envs  
│   │   ├── 📂 dev  
│   │   │   ├── 📄 main.tf      # Modules  
│   │   │   └── 📄 terraform.tfvars      # Assign the Variables  
│   │   ├── 📂 prod  
│   │   │   ├── 📄 main.tf      # Modules  
│   │   │   └── 📄 terraform.tfvars      # Assign the Variables  

</details>

<details>
<summary>📂 services — Application logic Microservices</summary>

│   ├── 📂 shazam-api → 📄 app.py  
│   ├── 📂 zip-validator → 📄 app.py  
│   ├── 📂 unzip-service → 📄 app.py  
│   ├── 📂 qa-service → 📄 app.py  
│   ├── 📂 render-360 → 📄 app.py  
│   ├── 📂 search-bot → 📄 app.py  

</details>

<details>
<summary>📂 k8s — Kubernetes deployment</summary>

│   └── 📄 shazam-api.yaml  

</details>

<details>
<summary>📂 ci-cd — Automation CI/CD pipelines</summary>

│   └── 📄 Jenkinsfile  

</details>

</details>


## PREREQUISITES (VERY IMPORTANT)
| Tool         | Why                         |
| ------------ | --------------------------- |
| Git          | Version control             |
| AWS CLI      | Authenticate to AWS         |
| Terraform    | Create cloud infrastructure |
| Docker       | Package applications        |
| kubectl      | Talk to Kubernetes          |
| Python 3.10+ | Run services                |

## Deployment HOW TO RUN (STEP BY STEP)
## 1. Clone
```bash
git clone https://github.com/you/3d-production-pipeline
cd 3d-production-pipeline
```
## 2. Create Infrastructure
```bash
aws configure
cd terraform/envs/prod
terraform init
terraform validate
terraform plan
terraform apply
```

## 3. Build & Push Docker images

```bash
docker build -t shazam-api services/shazam-api
docker tag shazam-api rupeshkumar2025/shazam-api:latest
docker push rupeshkumar2025/shazam-api:latest
```
## 4. AWS LOAD BALANCER CONTROLLER
Why

Kubernetes Ingress does not create ALBs by itself

AWS controller does this automatically

Install (Helm)
```bash
helm repo add eks https://aws.github.io/eks-charts
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  --namespace kube-system \
  --set clusterName=shazam-eks
```

## 3. Connect to Kubernetes

```bash
aws eks update-kubeconfig --region us-east-1 --name shazam-eks
kubectl get nodes
```
## 4. Deploy Services

```bash
kubectl apply -f k8s/
```
## Observability/MONITORING
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus prometheus-community/prometheus
helm repo add grafana https://grafana.github.io/helm-charts
helm install grafana grafana/grafana
```
Dashboards:
    Artist productivity
    QA rejection rate
    Pipeline latency
    GPU utilization
    Storage cost savings
    Search success rate

Alerts:
    QA backlog SLA breach
    Render failures
    ZIP validation spikes.

## CI/CD (JENKINS + GITHUB ACTIONS)

┌────────────────────────────────────────────────────────────────────────────┐
│                                 INTERNET                                   │
│                        (Users / Artists / Website)                          │
└───────────────────────────────┬────────────────────────────────────────────┘
                                │ HTTPS
                                ▼
┌────────────────────────────────────────────────────────────────────────────┐
│                          AWS ACCOUNT                                        │
│                                                                            │
│  ┌──────────────────────────────────────────────────────────────────────┐ │
│  │                                VPC                                   │ │
│  │                         CIDR: 10.0.0.0/16                            │ │
│  │                                                                      │ │
│  │  ┌──────────────────────────────┐      ┌──────────────────────────┐ │ │
│  │  │        PUBLIC SUBNET AZ-A     │      │     PUBLIC SUBNET AZ-B    │ │ │
│  │  │                              │      │                          │ │ │
│  │  │  ┌───────────────────────┐  │      │  ┌─────────────────────┐ │ │ │
│  │  │  │  ALB (Ingress)        │◄─┼──────┼─►│  ALB (Ingress)       │ │ │ │
│  │  │  │  Internet-Facing      │  │      │  │  Internet-Facing    │ │ │ │
│  │  │  └───────────────────────┘  │      │  └─────────────────────┘ │ │ │
│  │  │                              │      │                          │ │ │
│  │  │  NAT Gateway                 │      │  NAT Gateway             │ │ │
│  │  └───────────────┬──────────────┘      └─────────────┬────────────┘ │ │
│  │                  │                                     │              │ │
│  │──────────────────┼─────────────────────────────────────┼──────────────│ │
│  │                  │                                     │              │ │
│  │  ┌───────────────▼──────────────┐      ┌──────────────▼─────────────┐│ │
│  │  │     PRIVATE SUBNET AZ-A       │      │     PRIVATE SUBNET AZ-B     ││ │
│  │  │                              │      │                            ││ │
│  │  │  ┌────────────────────────┐ │      │ ┌────────────────────────┐ ││ │
│  │  │  │   EKS WORKER NODE       │ │      │ │   EKS WORKER NODE       │ ││ │
│  │  │  │   (EC2 + Docker)        │ │      │ │   (EC2 + Docker)        │ ││ │
│  │  │  │                        │ │      │ │                        │ ││ │
│  │  │  │  ┌──────────────────┐ │ │      │ │  ┌──────────────────┐ │ ││ │
│  │  │  │  │ POD: shazam-api  │ │ │      │ │  │ POD: shazam-api  │ │ ││ │
│  │  │  │  └──────────────────┘ │ │      │ │  └──────────────────┘ │ ││ │
│  │  │  │  ┌──────────────────┐ │ │      │ │  ┌──────────────────┐ │ ││ │
│  │  │  │  │ POD: unzip-svc   │ │ │      │ │  │ POD: render-360  │ │ ││ │
│  │  │  │  └──────────────────┘ │ │      │ │  └──────────────────┘ │ ││ │
│  │  │  │  ┌──────────────────┐ │ │      │ │  ┌──────────────────┐ │ ││ │
│  │  │  │  │ POD: qa-service  │ │ │      │ │  │ POD: search-bot  │ │ ││ │
│  │  │  │  └──────────────────┘ │ │      │ │  └──────────────────┘ │ ││ │
│  │  │  │                        │ │      │ │                        │ ││ │
│  │  │  │  ┌──────────────────┐ │ │      │ │  ┌──────────────────┐ │ ││ │
│  │  │  │  │ Prometheus Pod   │ │ │      │ │  │ Grafana Pod      │ │ ││ │
│  │  │  │  └──────────────────┘ │ │      │ │  └──────────────────┘ │ ││ │
│  │  │  └───────────┬────────────┘ │      │ └───────────┬────────────┘ ││ │
│  │  │              │               │      │             │              ││ │
│  │  └──────────────┼───────────────┘      └─────────────┼──────────────┘│ │
│  │                 │                                      │               │ │
│  │─────────────────┼──────────────────────────────────────┼───────────────│ │
│  │                 │                                      │               │ │
│  │            IRSA (IAM Role for ServiceAccount)           │               │ │
│  │                 │                                      │               │ │
│  │                 ▼                                      ▼               │ │
│  │            AWS STS (Temporary Credentials)                              │ │
│  │                                                                          │ │
│  │                 ▼                                                      │ │
│  │            S3 BUCKET (Assets, ZIPs, GLB, Renders)                        │ │
│  │                                                                          │ │
│  └──────────────────────────────────────────────────────────────────────┘ │
│                                                                            │
│  AUTOSCALING                                                               │
│  ┌─────────────────────────────────────────────────────────────────────┐ │
│  │  HPA (Horizontal Pod Autoscaler)                                     │ │
│  │   - CPU / Memory / Custom Metrics                                    │ │
│  │   - Adds / Removes Pods                                              │ │
│  │                                                                      │ │
│  │  Cluster Autoscaler                                                  │ │
│  │   - Adds / Removes EC2 nodes                                         │ │
│  └─────────────────────────────────────────────────────────────────────┘ │
│                                                                            │
└────────────────────────────────────────────────────────────────────────────┘

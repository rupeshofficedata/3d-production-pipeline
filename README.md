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
<summary><strong>3d-production-pipeline/</strong></summary>

├── README.md — Master documentation  
├── terraform/ — Infrastructure (AWS)  
│   ├── backend.tf — Remote state (S3)  
│   ├── providers.tf — Provider configuration  
│   ├── versions.tf — Provider versions  
│   ├── envs/  
│   │   ├── dev/  
│   │   └── main.tf — Modules  
│   ├── prod/  
│   │   └── main.tf — Modules  
├── services/ — Application logic Microservices  
│   ├── shazam-api/ → app.py  
│   ├── zip-validator/ → app.py  
│   ├── unzip-service/ → app.py  
│   ├── qa-service/ → app.py  
│   ├── render-360/ → app.py  
│   ├── search-bot/ → app.py  
├── k8s/ — Kubernetes deployment  
│   └── shazam-api.yaml  
├── ci-cd/ — Automation CI/CD pipelines  
│   └── Jenkinsfile  

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
## 3. Connect to Kubernetes

```bash
aws eks update-kubeconfig --region us-east-1 --name shazam-eks
kubectl get nodes
```
## 4. Deploy Services

```bash
kubectl apply -f k8s/
```
## Observability
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
    ZIP validation spikes
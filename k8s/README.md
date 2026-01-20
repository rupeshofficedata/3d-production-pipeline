Kubernetes runs all services.

Why Kubernetes?
- Scaling
- Self-healing
- Clear separation


k8s/shazam-api-sa.yaml
Replace:

<ACCOUNT_ID> → your AWS account ID

This file does one thing only:

It tells Kubernetes:
“Pods using this ServiceAccount may assume this IAM role.”

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: shazam-api
  namespace: shazam
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::<ACCOUNT_ID>:role/shazam-s3-access

```
🔁 HOW THIS CONNECTS TO IRSA (IMPORTANT)

In Terraform you defined:

namespace_service_accounts = ["shazam:shazam-api"]


That means Terraform expects:

Namespace: shazam

ServiceAccount name: shazam-api

This YAML must match exactly, or IRSA will silently fail.

## AUTOSCALING
shazam-api-hpa.yaml

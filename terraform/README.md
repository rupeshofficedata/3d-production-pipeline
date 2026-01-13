TERRAFORM BACKEND (VERY IMPORTANT CONCEPT)
1️⃣ WHAT IS A TERRAFORM BACKEND?

A Terraform backend is where Terraform stores its state file.

Terraform state:
    Remembers what resources exist
    Tracks IDs, ARNs, IPs
    Prevents duplicate creation
    Enables updates instead of recreation

2️⃣ WHY LOCAL STATE IS BAD (BEGINNER TRAP)

If you don’t use a backend:

terraform.tfstate (local file)


## Problems:

❌ Lost if laptop crashes
❌ Cannot be shared with team
❌ Two people can overwrite each other
❌ No locking

## 3️⃣ WHAT ACTUALLY CHANGED IN TERRAFORM (FACTS)

Historically:
    Terraform required DynamoDB for locking with S3

Now (Terraform ≥ 1.10):
    Terraform can use S3 native object locking
    DynamoDB is optional

👉 This relies on S3 Object Lock, not just S3 itself.

⚠️ S3 alone does NOT magically lock state.
Locking only works when Object Lock is enabled on the bucket.

| Feature          | DynamoDB      | S3 + Object Lock                |
| ---------------- | ------------- | ------------------------------- |
| State locking    | ✅ Very strong | ✅ Strong                        |
| Concurrent apply | ✅ Fully safe  | ⚠️ Safe if configured correctly |
| Team workflows   | ✅ Recommended | ⚠️ Limited                      |
| Solo learning    | ❌ Overkill    | ✅ Best choice                   |
| Setup complexity | ❌ Higher      | ✅ Lower                         |
| Industry usage   | ✅ Default     | 🟡 Emerging                     |

## 4️⃣ WHAT IS S3 OBJECT LOCK? (BEGINNER EXPLANATION)

S3 Object Lock:
    Prevents overwriting or deleting an object
    Works like a “write-once” lock
    Terraform uses this to prevent:
        Two applies at the same time
        State corruption

Terraform:
    Writes a .tflock object
    S3 blocks concurrent writes
    Terraform detects the lock

## 5️⃣ IMPORTANT LIMITATION (READ THIS CAREFULLY)

    ❗ You CANNOT enable Object Lock on an existing bucket

It must be enabled:

    At bucket creation
    Forever
    Cannot be turned off

This is an S3 rule, not Terraform.

## 6️⃣ CORRECT WAY TO CREATE THE BACKEND BUCKET (STEP-BY-STEP)
Step 1 — Create S3 bucket WITH Object Lock

    ```bash

    aws s3api create-bucket \
    --bucket shazam-terraform-state \
    --region us-east-1 \
    --object-lock-enabled-for-bucket
    
    ```
📌 This is the most important command.

Step 2 — Enable versioning (required by Object Lock)

    ```bash

    aws s3api put-bucket-versioning \
    --bucket shazam-terraform-state \
    --versioning-configuration Status=Enabled

    ```

Step 3 — Enable encryption

    ```bash

    aws s3api put-bucket-encryption \
    --bucket shazam-terraform-state \
    --server-side-encryption-configuration '{
        "Rules": [{
        "ApplyServerSideEncryptionByDefault": {
            "SSEAlgorithm": "AES256"
        }
        }]
    }'

    ```

Step 4 — (Optional but recommended) Block public access

    ```bash

    aws s3api put-public-access-block \
    --bucket shazam-terraform-state \
    --public-access-block-configuration \
    BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true

    ```

## 7️⃣ HOW TO VERIFY LOCKING IS WORKING
Terminal 1

    ```bash

    terraform apply
    
    ```
Terminal 2 (while first is running)

    ```bash

    terraform apply

    ```

Expected result:
Error acquiring the state lock

✅ This means locking is working.
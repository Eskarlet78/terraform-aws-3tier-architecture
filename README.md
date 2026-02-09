# Terraform AWS 3-Tier Production Architecture

This project provisions a **scalable, secure, production-style 3-tier infrastructure on AWS** using **Terraform**.

It demonstrates real-world cloud architecture and Infrastructure as Code (IaC) practices used by DevOps and Cloud Engineers.

---

## 🏗 Architecture Overview

```
Internet
   ↓
Application Load Balancer (Public Subnets)
   ↓
Auto Scaling EC2 App Servers (Private App Subnets)
   ↓
RDS MySQL Database (Private DB Subnets)
```

---

## 🚀 What This Project Builds

### 🌐 Networking
- Custom VPC
- Public, Private App, and Private DB subnets
- Internet Gateway (IGW)
- NAT Gateway for private outbound access
- Route tables and associations

### 🔐 Security
- Tier-based Security Groups
- Internet → ALB → App → DB traffic flow
- Database not publicly accessible

### ⚙ Compute Layer
- Launch Template
- Auto Scaling Group (ASG)
- EC2 instances in private subnets

### ⚖ Load Balancing
- Application Load Balancer (ALB)
- Target Groups and health checks

### 🗄 Database Layer
- RDS MySQL instance
- DB Subnet Group (private subnets only)

### 🧠 Terraform Best Practices
- Modular structure
- Environment separation (dev)
- Remote state (S3)
- State locking (DynamoDB)

---

## 📁 Project Structure

```
terraform-aws-3tier-architecture/
│
├── modules/
│   ├── vpc/
│   ├── security/
│   ├── autoscaling/
│   ├── alb/
│   └── rds/
│
└── environments/
    └── dev/
        ├── provider.tf
        ├── backend.tf
        ├── main.tf
        ├── variables.tf
        ├── terraform.tfvars
        └── outputs.tf
```

---

## 🛠 Prerequisites

Before using this project:

- AWS account
- IAM user with programmatic access
- AWS CLI installed
- Terraform installed

---

## 🔑 Configure AWS Credentials

```bash
aws configure
```

Enter:
- Access Key
- Secret Key
- Region (e.g. ap-south-1)

---

## 📦 Clone This Repository

```bash
git clone https://github.com/anirudht2025/terraform-aws-3tier-architecture.git
cd terraform-aws-3tier-architecture/environments/dev
```

---

## 🚀 Deploy Infrastructure

```bash
terraform init
terraform plan
terraform apply
```

Type `yes` when prompted.

After deployment, Terraform outputs the **ALB DNS name**.  
Open it in your browser to see:

```
Hello from App Server
```

---

## 🧨 Destroy Infrastructure

To avoid AWS charges:

```bash
terraform destroy
```

---

## 🎯 Key Skills Demonstrated

- Infrastructure as Code (Terraform)
- AWS networking and security
- Scalable architecture design
- Load balancing and auto scaling
- Private database deployment
- Remote state management
- Modular Terraform design

---

## 👤 Author

Anirudh T  
Aspiring DevOps / Cloud Engineer

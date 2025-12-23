# Architecture Overview

## Primary Region
**us-east-1**  
(All deployments and monitoring are documented for a single region to avoid conflicts.)

---

## High-Level Architecture

Developer
  ↓
GitHub Repository
  ↓
GitHub Actions (CI/CD)
  ├─ Security Gate
  ├─ Build Stage
  ├─ Deploy Stage
  └─ Smoke Tests
  ↓
AWS Infrastructure
  ├─ VPC
  ├─ EC2 (t2.micro)
  ├─ Security Groups
  ├─ IAM Roles (OIDC + Instance Profile)
  └─ Elastic IP
  ↓
Monitoring & Cost
  ├─ CloudWatch Logs
  ├─ CloudWatch Dashboard
  ├─ CloudWatch CPU Alarm
  └─ AWS Cost Anomaly Detection

---

## Component Responsibilities

### GitHub Actions
- Runs CI/CD pipeline
- Uses OIDC (no AWS keys stored)
- Enforces security and deployment order

### Terraform
- Provisions AWS infrastructure
- Manages EC2, networking, IAM
- Ensures repeatable deployments

### EC2 Instance
- Hosts Dockerized Flask application
- Managed via AWS SSM
- Logs shipped to CloudWatch

### Monitoring
- CloudWatch dashboards for visibility
- CPU alarm for performance alerts
- Cost anomaly detection for billing safety

---

## Design Decisions

| Decision | Reason |
|--------|--------|
| Single Region | Avoid operational confusion |
| EC2 over EKS | Free Tier friendly |
| No Load Balancer | Cost optimization |
| Dockerized App | Consistent deployment |
| CloudWatch | Native AWS monitoring |

---

## Security Boundaries
- GitHub → AWS: OIDC temporary credentials
- Internet → EC2: Security group controlled access
- EC2 → AWS Services: IAM instance role

---

## Summary
This architecture prioritizes **simplicity, security, and cost efficiency** while demonstrating real-world DevSecOps practices suitable for production environments.

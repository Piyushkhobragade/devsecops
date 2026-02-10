# **Cloud-Native DevSecOps Pipeline with Policy-as-Code & FinOps Guardrails**

**A production-grade DevSecOps pipeline that enforces security, compliance, and cost controls before infrastructure and code reach AWS.**

##   **What This Project Solves**

This repository contains a **production-grade, security-first implementation** for a secure-by-design software supply chain deploying a containerized Python application to AWS. The project adheres to strict **DevSecOps** and **FinOps** principles, enforcing compliance through Policy-as-Code (PaC) and immutable infrastructure patterns.

Key capabilities include:

* **Zero-Trust Authentication:** GitHub Actions authenticates via AWS OIDC (OpenID Connect) Federation. No long-lived IAM keys are stored.  
* **Automated Governance:** Custom Checkov policies **block** non-compliant infrastructure (e.g., untagged resources, expensive instance types) before provisioning.  
* **Shift-Left Security:** Integrated scanning for secrets, SAST, SCA, and container vulnerabilities.  
* **Cost Control:** Pre-deployment cost estimation and AWS Cost Anomaly detection.

##  **Architecture Decisions**

**Design Philosophy:** *Security, cost, and compliance are enforced at CI time — not reviewed manually after deployment.*

The infrastructure is provisioned using **Terraform** and orchestrated by **GitHub Actions**.

* **Compute:** Amazon EC2 (Dockerized runtime)  
* **Networking:** VPC, Public Subnet (Cost-optimized), Security Groups  
* **Observability:** CloudWatch Logs, Metrics, Alarms, SNS  
* **State Management:** S3 Backend with DynamoDB Locking

*Design Decision:* The architecture targets the us-east-1 region and utilizes a public subnet architecture to eliminate NAT Gateway costs, strictly adhering to AWS Free Tier limits while maintaining full operational visibility.


## **Secure Delivery Pipeline**

The deployment pipeline (.github/workflows/deploy.yml) enforces a strict quality gate:

1. **Security Analysis:**  
   * **TruffleHog:** **Blocks** commit history containing high-entropy secrets.  
   * **Bandit:** **Fails the pipeline** on critical Static Application Security Testing (SAST) findings.  
   * **Snyk/Trivy:** **Prevents merge** if dependencies contain known critical CVEs.  
2. **Artifact Generation:**  
   * Builds Docker image.  
   * **Trivy/Grype:** Scans container layers for OS vulnerabilities.  
3. **Infrastructure Validation:**  
   * **Infracost:** Calculates cost impact of the Pull Request.  
   * **Checkov:** **Blocks** non-compliant Terraform before provisioning (CIS benchmarks \+ Custom Policies).  
4. **Delivery:**  
   * terraform apply updates the infrastructure state.  
   * Smoke tests validate the /health endpoint.


## **Security Controls**

All controls are enforced automatically and fail the pipeline on violation — no manual approvals.

| Control Layer | Tooling | Enforcement / Outcome |
| :---- | :---- | :---- |
| **Secret Detection** | TruffleHog | **Pipeline Fails** (Pre-commit/Pre-build block) |
| **Code Security** | Bandit | **Build Fails** on High Severity |
| **Dependency Security** | Snyk / Trivy | **Merge Denied** on Critical CVEs |
| **Infrastructure Security** | Checkov / tfsec | **Deployment Blocked** on Misconfiguration |
| **Container Security** | Trivy | Image vulnerability scanning |
| **Identity** | AWS OIDC | Federated Authentication |

### **Policy-as-Code (Custom Implementation)**

Governance is enforced via custom Python-based Checkov policies found in the policies/ directory. **These policies act as hard gates, not advisory checks.**

* **CKV\_AWS\_CUSTOM\_1:** Enforces mandatory CostCenter tagging on all resources.  
* **CKV\_AWS\_CUSTOM\_2:** Restricts EC2 instances to t2.micro or t3.micro families.  
* **CKV\_AWS\_CUSTOM\_3:** Blocks SSH (Port 22\) access from global 0.0.0.0/0 CIDRs.

## **Observability**

Application and infrastructure health are monitored natively in AWS CloudWatch. **Monitoring is designed for operational response, not vanity metrics.**

**Operational Dashboard:**

**Automated Alerting:**

* **Log Aggregation:** Flask application logs and system logs are streamed to CloudWatch Log Groups.  
* **Metric Alarms:** SNS notifications trigger if CPU utilization \> 80% for 5 minutes.

## **Cost Management (FinOps)**

**This project demonstrates FinOps-aware DevOps, where cost is treated as a first-class constraint.**

* **Infracost:** Runs in CI to predict monthly spend changes.  
* **AWS Cost Anomaly Detection:** Monitors for spending spikes with a threshold of $1.00 USD.  
* **Resource Constraints:** Policy-as-Code prevents the instantiation of non-Free-Tier resources.

## **Verification**

**1\. Verify Infrastructure State**

terraform output public\_ip  
curl http://\<output\_ip\>:5000/health

**2\. Production Health Check**

**3\. Run Security Policies Locally**

checkov \-d ./terraform \--check CKV\_AWS\_CUSTOM\_1 \--external-checks-dir ./policies

## **Known Limitations**

* **Availability:** Single-AZ deployment (US-EAST-1a) to minimize data transfer costs.  
* **Network:** Public subnet placement avoids NAT Gateway charges but requires rigorous Security Group management.  
* **Secrets:** Runtime secrets utilize Terraform user\_data injection rather than AWS Secrets Manager to reduce API cost overhead.

## **Roadmap (Planned Enhancements)**

* TLS termination via Nginx reverse proxy  
* GitOps-based CD with ArgoCD  
* Private subnet isolation using NAT Instance

Author: Piyush Khobragade  
Role: Cloud DevSecOps Engineer (Security, Compliance & FinOps)

# Cost Analysis Report

**Project:** DevSecOps Pipeline  
**Primary Region:** us-east-1  
**Target Cost:** $0.00 (AWS Free Tier)

---

## 1. Executive Summary
This project demonstrates how a production-style DevSecOps pipeline can be built and operated within AWS Free Tier limits while maintaining security, monitoring, and cost visibility.

---

## 2. AWS Services Cost Breakdown

| Service | Usage | Free Tier Limit | Estimated Cost |
|------|------|----------------|----------------|
| EC2 (t2.micro) | ~720 hrs/month | 750 hrs | $0.00 |
| EBS (8 GB) | Root volume | 30 GB | $0.00 |
| S3 | Artifacts + state | 5 GB | $0.00 |
| CloudWatch Logs | <1 GB | 5 GB | $0.00 |
| SNS | Email alerts | 1,000 req | $0.00 |
| Cost Anomaly Detection | Enabled | Free | $0.00 |
| **Total** | | | **$0.00** |

---

## 3. Cost Control Measures

### Free Tier Enforcement
- t2.micro instance only
- Minimal EBS size
- Short log retention
- No managed services (RDS, EKS, ALB)

### Monitoring & Alerts
- AWS Cost Anomaly Detection
- CloudWatch usage visibility
- Email alerts for abnormal spend

---

## 4. Avoided Costs (Intentional)

| Service | Reason Avoided | Monthly Savings |
|------|----------------|----------------|
| EKS | High baseline cost | ~$70 |
| NAT Gateway | Not required | ~$32 |
| Load Balancer | Direct EC2 access | ~$16 |
| RDS | Stateless app | ~$15 |

**Estimated Monthly Savings:** ~$130+

---

## 5. FinOps Best Practices Demonstrated
- Cost-aware architecture decisions
- Continuous monitoring
- Avoidance of idle resources
- Documentation of trade-offs

---

## 6. Scaling Cost Estimate (Production)

| Change | Monthly Cost |
|-----|--------------|
| ALB + ASG | ~$50 |
| RDS (db.t3.micro) | ~$15 |
| Enhanced Monitoring | ~$10 |
| **Estimated Total** | ~$75–100 |

---

## 7. Conclusion
This project proves that **DevSecOps maturity does not require high cloud spend**.  
Security, monitoring, and automation were achieved with **zero monthly cost**.

---

**Prepared By:** Piyush Gobravade  
**Date:** $(date +"%Y-%m-%d")

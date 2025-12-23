# Security Policy

## Automated Security Controls

### 1. Secrets Detection
- **Tool:** TruffleHog
- **Trigger:** Every commit
- **Action:** Fail pipeline if secrets detected
- **Bypass:** Not allowed

### 2. Dependency Scanning
- **Tools:** Snyk, Trivy
- **Severity Threshold:** HIGH
- **Action:** Fail on HIGH/CRITICAL vulnerabilities
- **Exception Process:** Document in security-exceptions.yml

### 3. Static Code Analysis
- **Tools:** Bandit, Semgrep
- **Rules:** OWASP Top 10, Security Audit
- **Action:** Fail on HIGH severity issues

### 4. Container Scanning
- **Tools:** Trivy, Grype
- **Scope:** Base image + dependencies
- **Action:** Fail on CRITICAL vulnerabilities

## Manual Review Requirements
- All PRs require 1 approval
- Security scan results must be reviewed
- Exception requests must include remediation plan

## Incident Response
1. Rotate compromised secrets within 1 hour
2. Patch vulnerabilities within 7 days (HIGH), 30 days (MEDIUM)
3. Document all exceptions in audit log

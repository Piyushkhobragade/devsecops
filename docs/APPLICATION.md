# Application Architecture

## Overview
This is a deliberately vulnerable Python Flask REST API used to validate
DevSecOps security scanning, policy enforcement, and CI/CD security gates.

The application itself is NOT production-safe by design.

## Intentional Vulnerabilities

1. **Hardcoded Secret**
   - Location: `API_KEY` variable
   - Expected Detection: TruffleHog

2. **Injection Vulnerabilities**
   - Path traversal risk in `/user/<username>`
   - SSTI in `/render`
   - Command injection in `/ping`
   - Expected Detection: Bandit, Semgrep

3. **Insecure Deserialization**
   - Unsafe YAML loading in `/config`
   - Expected Detection: Bandit

4. **Vulnerable Dependencies**
   - Outdated Flask, PyYAML, cryptography
   - Expected Detection: Snyk, Trivy

## Endpoints

| Method | Endpoint | Purpose |
|------|---------|---------|
| GET | /health | Health check |
| GET | /api/v1/status | Secure status |
| GET | /user/<username> | Vulnerable user lookup |
| GET | /render | SSTI demo |
| GET | /ping | Command injection demo |
| POST | /config | Unsafe YAML load |

## Runtime Model

- Application is **not run locally**
- Executed via Docker container
- CI/CD builds and scans image automatically

## Why This Design

This application exists ONLY to:
- Prove security scanners work
- Demonstrate shift-left security
- Fail pipelines on real findings
- Provide evidence to recruiters


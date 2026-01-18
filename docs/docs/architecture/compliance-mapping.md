---
sidebar_position: 8
---

# Compliance Mapping

This document maps the AWS Landing Zone implementation to common compliance frameworks and provides guidance for audit preparation.

## Overview

The Landing Zone architecture supports compliance with multiple regulatory frameworks through a combination of preventive, detective, and responsive controls. This mapping helps organizations understand how the infrastructure supports their compliance requirements.

**Important**: This document describes how the Landing Zone helps meet compliance requirements. It does not constitute legal advice or guarantee compliance. Organizations should work with qualified compliance professionals to ensure their specific requirements are met.

## CIS AWS Foundations Benchmark

The Landing Zone implements controls aligned with the CIS AWS Foundations Benchmark v1.5.0.

### IAM Controls

| CIS Control | Description | Landing Zone Implementation | Status |
|-------------|-------------|----------------------------|--------|
| 1.4 | Ensure no root user access key exists | Root account monitored via Config rule | Implemented |
| 1.5 | Ensure MFA is enabled for root user | Manual verification required | Manual |
| 1.6 | Ensure hardware MFA is enabled for root user | Manual verification required | Manual |
| 1.7 | Eliminate use of root user for administrative tasks | IAM Identity Center for all access | Implemented |
| 1.8 | Ensure IAM password policy requires minimum length of 14 | Account password policy configured | Implemented |
| 1.9 | Ensure IAM password policy prevents password reuse | Password reuse prevention: 24 passwords | Implemented |
| 1.10 | Ensure multi-factor authentication is enabled for all IAM users | Config rule: iam-user-mfa-enabled | Implemented |
| 1.12 | Ensure credentials unused for 45 days are disabled | Config rule: iam-user-unused-credentials-check | Implemented |
| 1.14 | Ensure access keys are rotated every 90 days | Config rule: access-keys-rotated | Implemented |
| 1.16 | Ensure IAM policies attached only to groups or roles | Config rule: iam-user-no-policies-check | Implemented |
| 1.17 | Maintain current contact details | Manual verification in account settings | Manual |
| 1.18 | Ensure security contact information is registered | Manual verification in account settings | Manual |
| 1.19 | Ensure IAM instance roles are used for AWS resource access | SCP enforces IMDSv2, encourages instance roles | Implemented |
| 1.20 | Ensure a support role has been created | Support role created in management account | Implemented |

### Logging Controls

| CIS Control | Description | Landing Zone Implementation | Status |
|-------------|-------------|----------------------------|--------|
| 2.1 | Ensure CloudTrail is enabled in all regions | Organization trail covers all accounts | Implemented |
| 2.2 | Ensure CloudTrail log file validation is enabled | Log file validation enabled | Implemented |
| 2.3 | Ensure S3 bucket used for CloudTrail logs is not publicly accessible | Bucket policy denies public access | Implemented |
| 2.4 | Ensure CloudTrail trails are integrated with CloudWatch Logs | CloudTrail logs sent to CloudWatch | Implemented |
| 2.5 | Ensure AWS Config is enabled in all regions | Config enabled organization-wide | Implemented |
| 2.6 | Ensure S3 bucket access logging is enabled on CloudTrail S3 bucket | S3 access logging enabled | Implemented |
| 2.7 | Ensure CloudTrail logs are encrypted at rest using KMS | KMS encryption enabled | Implemented |
| 2.8 | Ensure rotation for customer-created KMS keys is enabled | KMS key rotation enabled | Implemented |
| 2.9 | Ensure VPC flow logging is enabled in all VPCs | VPC Flow Logs enabled for all VPCs | Implemented |

### Monitoring Controls

| CIS Control | Description | Landing Zone Implementation | Status |
|-------------|-------------|----------------------------|--------|
| 3.1 | Ensure a log metric filter and alarm exist for unauthorized API calls | CloudWatch metric filters configured | Implemented |
| 3.2 | Ensure a log metric filter and alarm exist for Management Console sign-in without MFA | CloudWatch metric filters configured | Implemented |
| 3.3 | Ensure a log metric filter and alarm exist for usage of root user | CloudWatch metric filters configured | Implemented |
| 3.4 | Ensure a log metric filter and alarm exist for IAM policy changes | CloudWatch metric filters configured | Implemented |
| 3.5 | Ensure a log metric filter and alarm exist for CloudTrail configuration changes | CloudWatch metric filters configured | Implemented |
| 3.6 | Ensure a log metric filter and alarm exist for AWS Management Console authentication failures | CloudWatch metric filters configured | Implemented |
| 3.7 | Ensure a log metric filter and alarm exist for disabling or scheduled deletion of KMS keys | CloudWatch metric filters configured | Implemented |
| 3.8 | Ensure a log metric filter and alarm exist for S3 bucket policy changes | CloudWatch metric filters configured | Implemented |
| 3.9 | Ensure a log metric filter and alarm exist for AWS Config configuration changes | CloudWatch metric filters configured | Implemented |
| 3.10 | Ensure a log metric filter and alarm exist for security group changes | CloudWatch metric filters configured | Implemented |
| 3.11 | Ensure a log metric filter and alarm exist for NACL changes | CloudWatch metric filters configured | Implemented |
| 3.12 | Ensure a log metric filter and alarm exist for network gateway changes | CloudWatch metric filters configured | Implemented |
| 3.13 | Ensure a log metric filter and alarm exist for route table changes | CloudWatch metric filters configured | Implemented |
| 3.14 | Ensure a log metric filter and alarm exist for VPC changes | CloudWatch metric filters configured | Implemented |

### Networking Controls

| CIS Control | Description | Landing Zone Implementation | Status |
|-------------|-------------|----------------------------|--------|
| 4.1 | Ensure no security groups allow ingress from 0.0.0.0/0 to port 22 | Config rule: restricted-ssh | Implemented |
| 4.2 | Ensure no security groups allow ingress from 0.0.0.0/0 to port 3389 | Config rule: restricted-common-ports | Implemented |
| 4.3 | Ensure the default security group restricts all traffic | Config rule: vpc-default-security-group-closed | Implemented |
| 4.4 | Ensure routing tables for VPC peering are least access | Manual review required | Manual |
| 4.5 | Ensure Network ACLs do not allow ingress from 0.0.0.0/0 to port 22 | Manual review required | Manual |
| 4.6 | Ensure Network ACLs do not allow ingress from 0.0.0.0/0 to port 3389 | Manual review required | Manual |

### Additional Controls

| CIS Control | Description | Landing Zone Implementation | Status |
|-------------|-------------|----------------------------|--------|
| 5.1 | Ensure no Network ACLs allow ingress from 0.0.0.0/0 to remote server administration ports | Config rules for common ports | Implemented |
| 5.2 | Ensure AWS Config is enabled | Config enabled organization-wide | Implemented |
| 5.3 | Ensure CloudTrail is enabled | Organization trail enabled | Implemented |
| 5.4 | Ensure GuardDuty is enabled | GuardDuty enabled in all accounts | Implemented |
| 5.5 | Ensure Security Hub is enabled | Security Hub enabled with CIS standard | Implemented |

## SOC 2 Control Mapping

The Landing Zone supports SOC 2 Trust Services Criteria through various controls.

### Common Criteria (CC)

| Control | Trust Service | Description | Landing Zone Implementation | Status |
|---------|---------------|-------------|----------------------------|--------|
| CC6.1 | Security | Logical and physical access controls | IAM Identity Center, MFA enforcement | Implemented |
| CC6.2 | Security | Prior to issuing credentials, registration and authorization | IAM Identity Center with SCIM provisioning | Implemented |
| CC6.3 | Security | Provisioning and modification of access credentials | Automated via IAM Identity Center | Implemented |
| CC6.6 | Security | Logical access removed when no longer required | Config rule: iam-user-unused-credentials-check | Implemented |
| CC6.7 | Security | Access credentials restricted to authorized users | Permission sets with least privilege | Implemented |
| CC7.2 | Security | Detection of security events | GuardDuty, Security Hub, CloudWatch | Implemented |
| CC7.3 | Security | Security incidents identified and communicated | SNS notifications, Security Hub findings | Implemented |
| CC7.4 | Security | Security incidents mitigated | Auto-remediation Lambda functions | Implemented |
| CC8.1 | Change Management | Change management process | Terraform IaC with version control | Implemented |

### Availability Criteria (A)

| Control | Description | Landing Zone Implementation | Status |
|---------|-------------|----------------------------|--------|
| A1.1 | Current processing capacity monitored | CloudWatch metrics and alarms | Implemented |
| A1.2 | System components protected against environmental factors | Multi-AZ architecture support | Implemented |
| A1.3 | Recovery plan procedures in place | Backup strategies documented | Documented |

### Confidentiality Criteria (C)

| Control | Description | Landing Zone Implementation | Status |
|---------|-------------|----------------------------|--------|
| C1.1 | Confidential information protected during transmission | TLS enforcement, VPC endpoints | Implemented |
| C1.2 | Confidential information protected during storage | KMS encryption for data at rest | Implemented |

## HIPAA Safeguards

The Landing Zone supports HIPAA technical and administrative safeguards for Protected Health Information (PHI).

**Note**: HIPAA compliance requires a Business Associate Agreement (BAA) with AWS. This mapping assumes a BAA is in place.

### Technical Safeguards

| Safeguard | Requirement | Landing Zone Implementation | Status |
|-----------|-------------|----------------------------|--------|
| 164.312(a)(1) | Access Control - Unique User Identification | IAM Identity Center with unique identities | Implemented |
| 164.312(a)(2)(i) | Access Control - Emergency Access Procedure | Break-glass IAM roles documented | Implemented |
| 164.312(a)(2)(iii) | Access Control - Automatic Logoff | Session timeout in IAM Identity Center | Implemented |
| 164.312(a)(2)(iv) | Access Control - Encryption and Decryption | KMS encryption for data at rest | Implemented |
| 164.312(b) | Audit Controls | CloudTrail, Config, VPC Flow Logs | Implemented |
| 164.312(c)(1) | Integrity - Mechanism to authenticate ePHI | CloudTrail log file validation | Implemented |
| 164.312(d) | Person or Entity Authentication | MFA enforcement via IAM policies | Implemented |
| 164.312(e)(1) | Transmission Security - Integrity Controls | TLS 1.2+ enforcement | Implemented |
| 164.312(e)(2)(i) | Transmission Security - Encryption | TLS for data in transit | Implemented |

### Administrative Safeguards

| Safeguard | Requirement | Landing Zone Implementation | Status |
|-----------|-------------|----------------------------|--------|
| 164.308(a)(1)(ii)(B) | Risk Management | Security Hub findings, GuardDuty alerts | Implemented |
| 164.308(a)(3)(i) | Workforce Clearance Procedure | IAM Identity Center access reviews | Manual |
| 164.308(a)(3)(ii)(A) | Authorization and Supervision | Permission sets with least privilege | Implemented |
| 164.308(a)(3)(ii)(B) | Workforce Clearance Procedure | Periodic access reviews required | Manual |
| 164.308(a)(3)(ii)(C) | Termination Procedures | IAM Identity Center user deprovisioning | Implemented |
| 164.308(a)(4)(i) | Information Access Management | IAM policies, SCPs | Implemented |
| 164.308(a)(5)(ii)(C) | Log-in Monitoring | CloudTrail console sign-in events | Implemented |
| 164.308(a)(6)(ii) | Response and Reporting | Incident response runbooks | Documented |
| 164.308(a)(7)(ii)(A) | Data Backup Plan | Backup strategies documented | Documented |
| 164.308(a)(7)(ii)(B) | Disaster Recovery Plan | DR procedures documented | Documented |

## PCI-DSS Controls

The Landing Zone supports PCI-DSS requirements for cardholder data environments (CDE).

**Note**: PCI-DSS compliance requires proper network segmentation to isolate CDE. This mapping assumes CDE is deployed in dedicated accounts/VPCs.

### Build and Maintain a Secure Network

| Requirement | Description | Landing Zone Implementation | Status |
|-------------|-------------|----------------------------|--------|
| 1.1 | Firewall configuration standards | Security groups, NACLs documented | Implemented |
| 1.2 | Firewall configurations restrict connections | Default deny, explicit allow rules | Implemented |
| 1.3 | Prohibit direct public access between Internet and CDE | Private subnets, NAT Gateway for egress | Implemented |
| 1.4 | Install personal firewall software on mobile devices | Not applicable (infrastructure only) | N/A |
| 2.1 | Always change vendor-supplied defaults | Custom AMIs, no default passwords | Implemented |
| 2.2 | Develop configuration standards for system components | Hardening standards documented | Documented |
| 2.3 | Encrypt all non-console administrative access | SSM Session Manager, no SSH keys | Implemented |
| 2.4 | Maintain inventory of system components | AWS Config resource inventory | Implemented |

### Protect Cardholder Data

| Requirement | Description | Landing Zone Implementation | Status |
|-------------|-------------|----------------------------|--------|
| 3.4 | Render PAN unreadable anywhere it is stored | KMS encryption at rest | Implemented |
| 3.5 | Document and implement procedures to protect keys | KMS key policies, rotation enabled | Implemented |
| 4.1 | Use strong cryptography for transmission over open networks | TLS 1.2+ enforcement | Implemented |
| 4.2 | Never send unprotected PANs by end-user messaging | Application-level control | N/A |

### Maintain a Vulnerability Management Program

| Requirement | Description | Landing Zone Implementation | Status |
|-------------|-------------|----------------------------|--------|
| 5.1 | Deploy anti-virus software | Inspector for vulnerability scanning | Implemented |
| 6.1 | Establish process to identify security vulnerabilities | Security Hub, Inspector | Implemented |
| 6.2 | Ensure all system components are protected from known vulnerabilities | Patch management via Systems Manager | Implemented |
| 6.3 | Develop secure software applications | Secure SDLC practices documented | Documented |

### Implement Strong Access Control Measures

| Requirement | Description | Landing Zone Implementation | Status |
|-------------|-------------|----------------------------|--------|
| 7.1 | Limit access to system components and cardholder data | IAM policies, permission sets | Implemented |
| 7.2 | Establish access control system for system components | IAM Identity Center RBAC | Implemented |
| 8.1 | Define and implement policies for user identification | Unique IAM identities | Implemented |
| 8.2 | Ensure proper user authentication management | MFA enforcement, password policies | Implemented |
| 8.3 | Secure all individual non-console administrative access | MFA for all administrative access | Implemented |
| 8.5 | Do not use group, shared, or generic IDs | Individual IAM identities required | Implemented |
| 8.6 | Use of other authentication mechanisms | MFA via IAM Identity Center | Implemented |

### Regularly Monitor and Test Networks

| Requirement | Description | Landing Zone Implementation | Status |
|-------------|-------------|----------------------------|--------|
| 10.1 | Implement audit trails to link access to individuals | CloudTrail logs all API calls | Implemented |
| 10.2 | Implement automated audit trails for all system components | CloudTrail, VPC Flow Logs, Config | Implemented |
| 10.3 | Record audit trail entries for all system components | CloudTrail captures all required events | Implemented |
| 10.4 | Synchronize all critical system clocks and times | NTP via VPC DHCP options | Implemented |
| 10.5 | Secure audit trails | CloudTrail logs encrypted, immutable | Implemented |
| 10.6 | Review logs and security events | CloudWatch Logs Insights, Security Hub | Implemented |
| 10.7 | Retain audit trail history for at least one year | S3 lifecycle policies for log retention | Implemented |
| 11.1 | Implement processes to test for presence of wireless access points | Not applicable (cloud infrastructure) | N/A |
| 11.2 | Run internal and external network vulnerability scans | Inspector vulnerability scanning | Implemented |
| 11.3 | Implement penetration testing methodology | Manual penetration testing required | Manual |
| 11.4 | Use intrusion detection/prevention techniques | GuardDuty for threat detection | Implemented |
| 11.5 | Deploy file integrity monitoring | Config for resource change detection | Implemented |

### Maintain an Information Security Policy

| Requirement | Description | Landing Zone Implementation | Status |
|-------------|-------------|----------------------------|--------|
| 12.1 | Establish, publish, maintain, and disseminate security policy | Security policies documented | Documented |
| 12.3 | Develop usage policies for critical technologies | Acceptable use policies required | Manual |
| 12.4 | Ensure security policy clearly defines information security responsibilities | RACI matrix documented | Documented |
| 12.10 | Implement incident response plan | Incident response runbooks | Documented |

## Evidence Collection Guide

### What Evidence to Collect

For compliance audits, collect the following evidence types:

#### Configuration Evidence

- **Terraform State**: Demonstrates infrastructure as code
- **AWS Config Snapshots**: Point-in-time configuration of resources
- **Security Hub Findings**: Compliance status for enabled standards
- **IAM Policy Documents**: Access control configurations
- **SCP Documents**: Organization-level guardrails

#### Activity Evidence

- **CloudTrail Logs**: API activity for specified time period
- **VPC Flow Logs**: Network traffic for specified time period
- **CloudWatch Logs**: Application and system logs
- **GuardDuty Findings**: Security threats detected
- **Access Analyzer Findings**: Unintended resource access

#### Compliance Evidence

- **Config Rule Compliance Reports**: Compliance status over time
- **Security Hub Compliance Reports**: CIS, PCI-DSS, HIPAA standards
- **Patch Compliance Reports**: Systems Manager patch status
- **Vulnerability Scan Reports**: Inspector findings

### Where Evidence is Stored

| Evidence Type | Storage Location | Retention Period |
|---------------|------------------|------------------|
| CloudTrail Logs | S3: `log-archive-cloudtrail-<account-id>` | 7 years |
| VPC Flow Logs | S3: `log-archive-vpcflowlogs-<account-id>` | 1 year |
| Config Snapshots | S3: `log-archive-config-<account-id>` | 7 years |
| GuardDuty Findings | Security Hub (Security Account) | 90 days |
| Security Hub Findings | Security Hub (Security Account) | 90 days |
| CloudWatch Logs | CloudWatch Logs (per account) | 1 year |
| Access Analyzer Findings | Access Analyzer (Security Account) | 90 days |

### Automated Evidence Collection

Use the following scripts to collect evidence for audits:

```bash
# Export CloudTrail logs for date range
aws s3 sync s3://log-archive-cloudtrail-<account-id>/AWSLogs/ \
  ./evidence/cloudtrail/ \
  --exclude "*" \
  --include "*2024/01/*"

# Export Config compliance report
aws configservice describe-compliance-by-config-rule \
  --output json > evidence/config-compliance.json

# Export Security Hub findings
aws securityhub get-findings \
  --filters '{"ComplianceStatus":[{"Value":"FAILED","Comparison":"EQUALS"}]}' \
  --output json > evidence/securityhub-findings.json

# Export IAM credential report
aws iam generate-credential-report
aws iam get-credential-report \
  --output text --query 'Content' | base64 -d > evidence/iam-credentials.csv
```

## Audit Preparation Checklist

### Pre-Audit Tasks (4-6 Weeks Before)

- [ ] Review and update security policies and procedures
- [ ] Run Security Hub compliance reports for all enabled standards
- [ ] Review and remediate high/critical Security Hub findings
- [ ] Verify CloudTrail is logging to correct S3 bucket
- [ ] Verify Config is recording all required resource types
- [ ] Review IAM users and remove unused accounts
- [ ] Review IAM access keys and rotate if needed
- [ ] Review MFA status for all privileged users
- [ ] Export compliance reports for required time period
- [ ] Prepare architecture diagrams (network, security, data flow)
- [ ] Document any exceptions or compensating controls
- [ ] Review and update incident response runbooks
- [ ] Verify backup and disaster recovery procedures

### Documentation Requirements

Prepare the following documentation for auditors:

#### Architecture Documentation

- [ ] Network architecture diagram
- [ ] Security architecture diagram
- [ ] Data flow diagrams
- [ ] Account structure and OU hierarchy
- [ ] IAM Identity Center permission set matrix

#### Policy Documentation

- [ ] Information security policy
- [ ] Incident response policy
- [ ] Access control policy
- [ ] Change management policy
- [ ] Data classification policy
- [ ] Acceptable use policy

#### Operational Documentation

- [ ] Runbooks for common operations
- [ ] Incident response procedures
- [ ] Disaster recovery procedures
- [ ] Backup and restore procedures
- [ ] Patch management procedures

#### Compliance Documentation

- [ ] Risk assessment
- [ ] Control matrix (framework to implementation mapping)
- [ ] Exception documentation
- [ ] Penetration test results (if applicable)
- [ ] Vulnerability scan results

### Access Provisioning for Auditors

#### Read-Only Access

Create a dedicated IAM Identity Center permission set for auditors:

```hcl
# SecurityAuditor permission set
resource "aws_ssoadmin_permission_set" "security_auditor" {
  name             = "SecurityAuditor"
  description      = "Read-only access for security auditors"
  instance_arn     = aws_ssoadmin_instance.main.arn
  session_duration = "PT8H"
}

resource "aws_ssoadmin_managed_policy_attachment" "security_audit" {
  instance_arn       = aws_ssoadmin_instance.main.arn
  permission_set_arn = aws_ssoadmin_permission_set.security_auditor.arn
  managed_policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
}

resource "aws_ssoadmin_managed_policy_attachment" "view_only" {
  instance_arn       = aws_ssoadmin_instance.main.arn
  permission_set_arn = aws_ssoadmin_permission_set.security_auditor.arn
  managed_policy_arn = "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
}
```

#### Evidence Access

Grant auditors access to evidence S3 buckets:

```hcl
# S3 bucket policy for auditor access
data "aws_iam_policy_document" "auditor_evidence_access" {
  statement {
    sid    = "AuditorReadAccess"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.auditor_role.arn]
    }
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.cloudtrail_logs.arn,
      "${aws_s3_bucket.cloudtrail_logs.arn}/*"
    ]
  }
}
```

#### Time-Limited Access

Use temporary credentials with expiration:

```bash
# Create temporary credentials for auditor (12 hours)
aws sts assume-role \
  --role-arn arn:aws:iam::123456789012:role/AuditorRole \
  --role-session-name audit-session-2024-01 \
  --duration-seconds 43200
```

### During Audit

- [ ] Provide auditors with access credentials
- [ ] Schedule kickoff meeting to review scope
- [ ] Provide access to documentation repository
- [ ] Assign point of contact for auditor questions
- [ ] Track auditor requests and responses
- [ ] Document any findings or observations
- [ ] Schedule daily check-ins with audit team

### Post-Audit

- [ ] Review audit findings and recommendations
- [ ] Create remediation plan for findings
- [ ] Update documentation based on feedback
- [ ] Implement process improvements
- [ ] Schedule follow-up audit (if required)

## Continuous Compliance

### AWS Config Rules for Compliance

The Landing Zone deploys Config rules that continuously monitor compliance:

#### CIS Benchmark Rules

```hcl
# Root account MFA
aws_config_config_rule.root_account_mfa_enabled

# IAM password policy
aws_config_config_rule.iam_password_policy

# CloudTrail enabled
aws_config_config_rule.cloudtrail_enabled

# S3 bucket public access
aws_config_config_rule.s3_bucket_public_read_prohibited
aws_config_config_rule.s3_bucket_public_write_prohibited

# Security group rules
aws_config_config_rule.restricted_ssh
aws_config_config_rule.restricted_rdp
```

#### Custom Compliance Rules

```hcl
# Require encryption for EBS volumes
aws_config_config_rule.encrypted_volumes

# Require VPC Flow Logs
aws_config_config_rule.vpc_flow_logs_enabled

# Require IMDSv2
aws_config_config_rule.ec2_imdsv2_check
```

### Security Hub Standards

Security Hub continuously evaluates compliance with enabled standards:

#### Enabled Standards

- **CIS AWS Foundations Benchmark v1.4.0**: 43 controls
- **AWS Foundational Security Best Practices v1.0.0**: 50+ controls
- **PCI DSS v3.2.1**: 40+ controls (optional)

#### Compliance Scoring

Security Hub provides a compliance score for each standard:

```
CIS AWS Foundations Benchmark: 87% (38/43 controls passing)
AWS Foundational Security Best Practices: 92% (46/50 controls passing)
```

#### Suppressing Findings

For accepted risks or compensating controls, suppress findings:

```bash
# Suppress a specific finding
aws securityhub update-findings \
  --filters '{"Id":[{"Value":"arn:aws:securityhub:...","Comparison":"EQUALS"}]}' \
  --note '{"Text":"Accepted risk - compensating control in place","UpdatedBy":"security-team"}' \
  --workflow '{"Status":"SUPPRESSED"}'
```

### Automated Remediation

The Landing Zone includes automated remediation for common compliance violations:

#### Auto-Remediation Lambda Functions

```hcl
# Remediate non-compliant S3 buckets
module "s3_remediation" {
  source = "../modules/auto-remediation"
  
  rule_name    = "s3-bucket-public-read-prohibited"
  lambda_function = "remediate-s3-public-access"
}

# Remediate security group violations
module "sg_remediation" {
  source = "../modules/auto-remediation"
  
  rule_name    = "restricted-ssh"
  lambda_function = "remediate-security-group-ssh"
}
```

#### Remediation Workflow

1. Config rule detects non-compliance
2. EventBridge rule triggers Lambda function
3. Lambda function remediates the issue
4. SNS notification sent to security team
5. Security Hub finding updated

### Compliance Dashboards

#### Security Hub Dashboard

View compliance status across all accounts:

```
AWS Console → Security Hub → Summary → Security Standards
```

#### Custom CloudWatch Dashboard

Create custom dashboards for compliance metrics:

```hcl
resource "aws_cloudwatch_dashboard" "compliance" {
  dashboard_name = "compliance-overview"
  
  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/Config", "ComplianceScore", { stat = "Average" }]
          ]
          title = "Config Compliance Score"
        }
      }
    ]
  })
}
```

### Compliance Reporting

#### Weekly Compliance Reports

Automated weekly reports sent to security team:

```bash
# Generate weekly compliance report
aws securityhub get-findings \
  --filters '{"ComplianceStatus":[{"Value":"FAILED","Comparison":"EQUALS"}]}' \
  --max-results 100 | \
  jq -r '.Findings[] | [.Title, .Severity.Label, .Resources[0].Id] | @csv' > \
  weekly-compliance-report.csv
```

#### Monthly Executive Summary

High-level compliance metrics for leadership:

- Overall compliance score by framework
- Trend analysis (improving/declining)
- Top 5 recurring findings
- Remediation velocity
- Open high/critical findings

## References

- [CIS AWS Foundations Benchmark v1.5.0](https://www.cisecurity.org/benchmark/amazon_web_services)
- [AWS Security Hub User Guide](https://docs.aws.amazon.com/securityhub/latest/userguide/)
- [AWS Config Developer Guide](https://docs.aws.amazon.com/config/latest/developerguide/)
- [AWS Compliance Programs](https://aws.amazon.com/compliance/programs/)
- [HIPAA on AWS](https://aws.amazon.com/compliance/hipaa-compliance/)
- [PCI DSS on AWS](https://aws.amazon.com/compliance/pci-dss-level-1-faqs/)
- [SOC 2 on AWS](https://aws.amazon.com/compliance/soc-faqs/)

---
sidebar_position: 2
---

# Control Tower Setup

AWS Control Tower is the foundation of this landing zone. This guide covers the prerequisites and setup process.

## Prerequisites

Before deploying this landing zone template, you need:

1. **AWS Account** - A fresh AWS account to serve as the Management account
2. **AWS Organizations** - Not enabled (Control Tower will create it)
3. **IAM Identity Center** - Not enabled (Control Tower will configure it)
4. **Email Addresses** - Unique emails for:
   - Log Archive account
   - Audit account
   - AFT Management account
   - Additional accounts you plan to create

:::warning Fresh Account Recommended
Control Tower works best with a fresh AWS account. If using an existing account with Organizations already enabled, you'll need to follow the [Control Tower with existing Organizations](https://docs.aws.amazon.com/controltower/latest/userguide/existing-orgs.html) guide.
:::

## Deploy Control Tower

### Step 1: Enable Control Tower

1. Sign in to the AWS Management Console as the root user or an IAM user with administrator permissions
2. Navigate to **AWS Control Tower** service
3. Click **Set up landing zone**
4. Configure the following:

| Setting | Recommendation |
|---------|---------------|
| **Home Region** | Your primary region (e.g., `us-east-1`) |
| **Additional Regions** | Regions where you'll deploy workloads |
| **Foundational OU** | `Security` (default) |
| **Additional OU** | `Sandbox` (default) |
| **Log Archive Account** | Create new with dedicated email |
| **Audit Account** | Create new with dedicated email |

5. Review and accept the service permissions
6. Click **Set up landing zone**

:::info Setup Time
Control Tower setup takes approximately 30-60 minutes to complete.
:::

### Step 2: Create Additional OUs

After Control Tower setup completes, create additional OUs via the Control Tower console:

1. Navigate to **Control Tower** → **Organization**
2. Click **Create organizational unit**
3. Create the following OUs:

| OU Name | Purpose | Parent |
|---------|---------|--------|
| **Infrastructure** | Network Hub, Shared Services, AFT | Root |
| **Workloads** | Production and staging workloads | Root |
| **Workloads/Production** | Production accounts | Workloads |
| **Workloads/Staging** | Staging accounts | Workloads |
| **Workloads/Development** | Development accounts | Workloads |

### Step 3: Enable Guardrails

Control Tower comes with mandatory guardrails. Enable additional recommended guardrails:

1. Navigate to **Control Tower** → **Guardrails**
2. Enable **Strongly Recommended** guardrails for all OUs
3. Consider enabling **Elective** guardrails based on your compliance needs

Key guardrails to enable:

| Guardrail | Type | Purpose |
|-----------|------|---------|
| Disallow public read access to S3 | Preventive | Data protection |
| Disallow public write access to S3 | Preventive | Data protection |
| Detect MFA not enabled for root | Detective | Identity security |
| Detect public RDS instances | Detective | Data protection |
| Detect unrestricted SSH | Detective | Network security |

### Step 4: Configure IAM Identity Center

1. Navigate to **IAM Identity Center**
2. Configure identity source:
   - **IAM Identity Center directory** (default) - for small teams
   - **External IdP** - for enterprise (Okta, Azure AD, etc.)
3. Create Permission Sets:
   - `AdministratorAccess` - Full admin access
   - `ReadOnlyAccess` - Audit and review
   - `PowerUserAccess` - Developer access
4. Create Groups and assign users

## Verify Control Tower Setup

Before proceeding with AFT deployment, verify:

```bash
# List OUs (from Management account)
aws organizations list-organizational-units-for-parent \
  --parent-id $(aws organizations list-roots --query 'Roots[0].Id' --output text)

# List accounts
aws organizations list-accounts

# Verify Control Tower status
aws controltower list-enabled-controls \
  --target-identifier arn:aws:organizations::ACCOUNT_ID:ou/o-xxxxx/ou-xxxx-xxxxxxxx
```

## Account IDs for AFT

Collect these account IDs for AFT setup:

| Account | How to Find |
|---------|-------------|
| Management Account ID | AWS Console → top-right → Account ID |
| Log Archive Account ID | Control Tower → Organization → Log Archive |
| Audit Account ID | Control Tower → Organization → Audit |

## Next Steps

Once Control Tower is deployed:

1. [Create AFT Management Account](../runbooks/deployment#step-1-create-aft-account)
2. [Deploy AFT](../runbooks/deployment#step-2-deploy-aft)
3. [Configure Account Customizations](../modules/aft)

## Troubleshooting

### Control Tower Setup Failed

Check CloudFormation stacks in the Management account:
- `AWSControlTowerBP-*` stacks
- Review events for failure reasons

Common issues:
- **Service limits** - Request limit increases before retry
- **Email already used** - Use unique emails for each account
- **Region not enabled** - Enable regions in Account Settings first

### Cannot Create OUs

Ensure you're using the Control Tower console, not AWS Organizations directly. Control Tower needs to register OUs to apply guardrails.

### Guardrails Not Applying

1. Verify OU is registered with Control Tower
2. Check guardrail drift: **Control Tower** → **Landing zone settings** → **Repair**

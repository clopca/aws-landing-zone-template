# AFT Patterns

Pre-configured deployment patterns for AWS Landing Zone using Account Factory for Terraform (AFT).

## Available Patterns

| Pattern | Description | Use Case |
|---------|-------------|----------|
| [single-region-basic](./single-region-basic/) | Basic single region deployment | Getting started, simple workloads |
| [multi-region-basic](./multi-region-basic/) | Two-region deployment with DR | Production workloads requiring DR |

## Pattern Selection Guide

### Choose `single-region-basic` if:
- You're getting started with AWS Landing Zone
- Your workloads don't require multi-region DR
- You want minimal complexity
- Cost optimization is a priority

### Choose `multi-region-basic` if:
- You need disaster recovery capabilities
- Compliance requires multi-region data residency
- You have production workloads with high availability requirements
- You need cross-region backup

## How to Use Patterns

1. **Copy the pattern** to your AFT repository:
   ```bash
   cp -r terraform/patterns/single-region-basic/* terraform/aft/
   ```

2. **Customize variables** in each component:
   - `aft-global-customizations/terraform/variables.tf`
   - `aft-account-customizations/WORKLOAD/terraform/variables.tf`

3. **Update account requests** in `aft-account-request/terraform/main.tf`

4. **Deploy via AFT pipeline**

## Pattern Structure

```
pattern-name/
├── README.md                    # Pattern documentation
├── aft-account-customizations/  # Account-specific customizations
│   └── WORKLOAD/
│       ├── terraform/
│       │   ├── main.tf
│       │   ├── variables.tf
│       │   ├── outputs.tf
│       │   └── versions.tf
│       └── api_helpers/
│           ├── pre-api-helpers.sh
│           └── post-api-helpers.sh
├── aft-global-customizations/   # Applied to all accounts
│   └── terraform/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── versions.tf
└── aft-account-request/         # Example account requests
    └── terraform/
        └── main.tf
```

## Customization

Each pattern can be customized by:

1. **Modifying global customizations**: Changes applied to ALL accounts
2. **Adding account customizations**: Create new folders under `aft-account-customizations/`
3. **Adjusting variables**: Update default values in `variables.tf`
4. **Adding modules**: Reference modules from `../../modules/`

## Prerequisites

- AWS Control Tower deployed
- AFT installed and configured
- Terraform >= 1.5.0
- AWS CLI configured with appropriate permissions

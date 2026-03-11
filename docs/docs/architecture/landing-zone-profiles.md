---
sidebar_position: 5
description: Supported customer-selectable architecture profiles for ingress, egress, and traffic inspection.
---

# Landing Zone Profiles

This landing zone should support a small number of validated architecture profiles instead of exposing every network and security choice as an independent Terraform toggle.

That keeps the platform scalable in two ways:

- customers answer a short questionnaire in business and control terms
- the platform maps those answers to a supported multi-account blueprint

The result is a safer contract than a large set of loosely related booleans. It reduces invalid combinations, makes the deployment path easier to automate, and keeps the reusable Terraform modules focused on primitives instead of customer-specific policy.

:::info Current State
The current repository implements the baseline hub-and-spoke pattern and parts of the centralized networking path. The profile model below is the target contract for making those choices explicit and supportable.
:::

## Design Rules

- Keep the governance baseline fixed for every customer: AWS Organizations, OUs, logging, identity baseline, account vending, stack validation, and shared inter-stack contracts.
- Offer a small set of supported profiles, not a free-form matrix of infrastructure booleans.
- Reject unsupported combinations early in validation.
- Treat profile changes as architecture migrations, not as casual in-place toggles after production rollout.

## Fixed Baseline

These capabilities should stay common across all customers and profiles:

- Control Tower foundation and core accounts
- centralized logging and audit retention
- AFT-based account vending and baseline customizations
- organization guardrails and delegated admin registration
- provider, backend, tagging, and validation conventions
- SSM catalog contracts between shared stacks

## Customer Questionnaire

Use the following questions before the first deployment. They should be captured in a customer profile document and later mapped to a supported Terraform pattern.

| Question | Typical Answers | Why It Matters |
|----------|-----------------|----------------|
| Must all internet ingress terminate in the network account? | `yes`, `no` | Decides between centralized and workload-owned ingress. |
| Must all outbound internet traffic traverse shared controls? | `yes`, `no` | Drives centralized egress design and route-table strategy. |
| Is east-west inspection required between VPCs or accounts? | `none`, `selective`, `mandatory` | Determines whether a dedicated inspection path is needed. |
| Is AWS-managed inspection acceptable? | `yes`, `no` | Chooses between AWS Network Firewall and third-party appliances. |
| Is TLS decryption required? | `yes`, `no` | Often forces a third-party inspection stack. |
| Can workload teams expose internet-facing services directly from workload accounts? | `yes`, `no` | Affects ingress centralization and team autonomy. |
| Is hybrid connectivity part of the landing zone? | `none`, `vpn`, `direct-connect`, `both` | Shapes the network account and DNS resolver requirements. |
| Are there regulatory controls that require centralized network enforcement? | `yes`, `no` | Pushes toward centralized ingress and inspection. |
| Is cost minimization more important than maximum central control? | `cost-first`, `balanced`, `control-first` | Helps choose between lightweight and inspection-heavy profiles. |
| Are multi-region workloads required from day one? | `yes`, `no` | Affects TGW, DNS, inspection placement, and failover assumptions. |

## Supported Profiles

These should be the supported landing-zone blueprints.

| Profile | Ingress | Egress | Inspection | Best Fit | Main Trade-Off |
|---------|---------|--------|------------|----------|----------------|
| `baseline-spoke` | Decentralized | Local or limited shared services routing | None inline | Fastest onboarding, low-complexity customers | Least centralized control |
| `central-egress` | Decentralized | Centralized in network account | DNS policy and optional outbound inspection | Enterprises that want shared outbound controls without centralizing public entry points | More TGW and routing complexity |
| `central-security-edge` | Centralized | Centralized | Centralized AWS-managed inspection | Security-first customers that require strong north-south control | Higher cost and operational coupling |
| `third-party-inspection` | Centralized | Centralized | Gateway Load Balancer plus partner appliances | Customers needing deep packet inspection, IDS/IPS, or TLS decryption | Highest cost, highest operational complexity |

## Profile Guidance

### `baseline-spoke`

Use this when the customer wants a clean multi-account baseline without forcing all traffic through the network account.

- workload accounts can own public ALBs, NLBs, or API endpoints
- shared routing still uses Transit Gateway for east-west access
- best starting point when control requirements are moderate

### `central-egress`

Use this when outbound governance matters more than centralized public ingress.

- workload accounts keep their own ingress where needed
- outbound internet access moves through the network account
- a good fit when security needs common DNS and egress controls without redesigning every application entry point

### `central-security-edge`

Use this when the customer wants the network account to be the primary security choke point.

- internet ingress terminates centrally
- outbound traffic also exits centrally
- AWS Network Firewall or equivalent managed controls are applied consistently
- this is the closest fit to a control-heavy AWS Security Reference Architecture style network account

### `third-party-inspection`

Use this when AWS-managed controls are not enough.

- Gateway Load Balancer fronts third-party appliances
- suitable for deep packet inspection, advanced IDS/IPS, or mandatory TLS inspection
- should be treated as a premium profile with stronger operational readiness requirements

## Mapping Rules

The questionnaire should map to profiles through simple, auditable rules.

| Condition | Recommended Profile |
|-----------|---------------------|
| No centralized ingress, no mandatory inline inspection, moderate control needs | `baseline-spoke` |
| Centralized outbound controls required, but workload-owned ingress is allowed | `central-egress` |
| Centralized ingress plus centralized inspection with AWS-managed controls | `central-security-edge` |
| TLS decryption, deep packet inspection, or mandatory third-party controls | `third-party-inspection` |

The platform should reject combinations such as:

- mandatory centralized ingress together with workload-owned public entry points
- mandatory east-west inspection with no inspection profile selected
- TLS decryption requested with an AWS-managed-only profile

## Recommended Repo Contract

The customer should answer the questionnaire once, and the platform should store the result as a profile contract. A simple future-facing example:

```yaml
version: 1
profile: central-egress

governance:
  compliance_tier: standard
  multi_region: false

network:
  centralized_ingress: false
  centralized_egress: true
  east_west_inspection: selective
  firewall_stack: aws_managed
  tls_decryption: false
  hybrid_connectivity: direct-connect

operations:
  workload_owned_public_ingress: true
  optimization_goal: balanced
```

This file should not directly replace Terraform inputs. Instead:

- the profile selects a supported pattern under `terraform/patterns/profiles/`
- environment-specific values such as CIDRs, account IDs, and regions stay in separate stack variables
- CI validates the profile before Terraform is rendered or applied

## Implementation Model

When this becomes code, the repo should use the following structure:

1. A customer profile file captures answers in business terms.
2. A renderer or orchestration layer maps the file to a supported Terraform composition.
3. Shared modules stay primitive-level and reusable.
4. Profiles own the composition decisions: ingress, egress, inspection, and routing patterns.
5. Unsupported combinations fail before any Terraform plan is created.

Do not expose every underlying network primitive directly to the customer. That approach scales poorly and creates long-term technical debt in the composition layer.

## Operational Notes

- Changing from `baseline-spoke` to `central-security-edge` is a migration project, not a routine variable flip.
- Profiles should be chosen before the first production deployment whenever possible.
- The default recommendation for most customers is to start with `baseline-spoke` or `central-egress` unless compliance or inspection requirements clearly justify a heavier model.

## AWS Reference Patterns

- [AWS landing zone customization guidance](https://docs.aws.amazon.com/prescriptive-guidance/latest/strategy-migration/aws-landing-zone.html)
- [Decentralized ingress pattern](https://docs.aws.amazon.com/prescriptive-guidance/latest/transitioning-to-multiple-aws-accounts/decentralized-ingress.html)
- [Centralized egress pattern](https://docs.aws.amazon.com/prescriptive-guidance/latest/transitioning-to-multiple-aws-accounts/centralized-egress.html)
- [AWS Security Reference Architecture network account](https://docs.aws.amazon.com/prescriptive-guidance/latest/security-reference-architecture/network.html)
- [Inline traffic inspection with third-party appliances and GWLB](https://docs.aws.amazon.com/prescriptive-guidance/latest/inline-traffic-inspection-third-party-appliances/welcome.html)

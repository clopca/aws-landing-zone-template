import type {ReactNode} from 'react';
import clsx from 'clsx';
import Heading from '@theme/Heading';
import styles from './styles.module.css';
import { 
  Shield, 
  Network, 
  Users, 
  Workflow, 
  CheckCircle, 
  Code2 
} from 'lucide-react';

type FeatureItem = {
  title: string;
  Icon: React.ElementType;
  description: ReactNode;
};

const FeatureList: FeatureItem[] = [
  {
    title: 'Multi-Account Governance',
    Icon: Users,
    description: (
      <>
        AWS Organizations with OU structure, Service Control Policies (SCPs), 
        and centralized billing for enterprise-scale management.
      </>
    ),
  },
  {
    title: 'Security Baseline',
    Icon: Shield,
    description: (
      <>
        GuardDuty threat detection, Security Hub compliance, AWS Config rules, 
        and IAM Access Analyzer enabled by default.
      </>
    ),
  },
  {
    title: 'Network Hub',
    Icon: Network,
    description: (
      <>
        Transit Gateway hub-and-spoke topology with centralized egress/ingress, 
        VPC endpoints, and hybrid connectivity readiness.
      </>
    ),
  },
  {
    title: 'Account Factory (AFT)',
    Icon: Workflow,
    description: (
      <>
        Automated account provisioning with GitOps workflow, customizable baselines, 
        and self-service capabilities for teams.
      </>
    ),
  },
  {
    title: 'Compliance Ready',
    Icon: CheckCircle,
    description: (
      <>
        Aligned with CIS Benchmarks and Security Reference Architecture. 
        Includes audit trails with CloudTrail and evidence collection.
      </>
    ),
  },
  {
    title: 'Infrastructure as Code',
    Icon: Code2,
    description: (
      <>
        100% Terraform architecture with modular, reusable components. 
        Designed for CI/CD pipelines and automated testing.
      </>
    ),
  },
];

function Feature({title, Icon, description}: FeatureItem) {
  return (
    <div className={clsx('col col--4')}>
      <div className="text--center">
        <Icon className={styles.featureSvg} size={48} strokeWidth={1.5} />
      </div>
      <div className="text--center padding-horiz--md">
        <Heading as="h3">{title}</Heading>
        <p>{description}</p>
      </div>
    </div>
  );
}

export default function HomepageFeatures(): ReactNode {
  return (
    <section className={styles.features}>
      <div className="container">
        <div className="row">
          {FeatureList.map((props, idx) => (
            <Feature key={props.title} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}

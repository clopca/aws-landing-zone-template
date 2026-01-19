import type {ReactNode} from 'react';
import clsx from 'clsx';
import Link from '@docusaurus/Link';
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';
import Layout from '@theme/Layout';
import HomepageFeatures from '@site/src/components/HomepageFeatures';
import Heading from '@theme/Heading';
import { 
  Layout as LayoutIcon, 
  Shield, 
  FileText, 
  Network, 
  Settings, 
  GitBranch, 
  Terminal, 
  Play,
  ArrowRight
} from 'lucide-react';

import styles from './index.module.css';

function HomepageHeader() {
  const {siteConfig} = useDocusaurusContext();
  return (
    <header className={styles.heroBanner}>
      <div className={styles.heroContainer}>
        <Heading as="h1" className={styles.heroTitle}>
          Production-Ready <br />
          <span className="text-gradient">AWS Landing Zone</span>
        </Heading>
        <p className={styles.heroSubtitle}>
          Deploy a secure, multi-account AWS Organization with Terraform in minutes. 
          Built on AWS best practices and Security Reference Architecture.
        </p>
        <div className={styles.buttons}>
          <Link
            className="button button--primary button--lg"
            to="/docs/intro">
            Get Started
            <ArrowRight className="margin-left--sm" size={18} />
          </Link>
          <Link
            className="button button--secondary button--lg"
            to="https://github.com/clopca/aws-landing-zone-template">
            View on GitHub
          </Link>
        </div>
      </div>
    </header>
  );
}

function ArchitectureSection() {
  return (
    <section className={styles.architectureSection}>
      <div className="container">
        <Heading as="h2" className={styles.sectionTitle}>Enterprise-Grade Architecture</Heading>
        <p className={styles.sectionDescription}>
          A fully automated, multi-account structure designed for security and scalability.
        </p>
        
        <div className={styles.architectureDiagram}>
          {/* Connection Lines */}
          <div className={styles.connectorVertical} />
          <div className={styles.connectorHorizontal} />
          <div className={styles.connectorDrop} style={{left: '10%'}} />
          <div className={styles.connectorDrop} style={{left: '30%'}} />
          <div className={styles.connectorDrop} style={{left: '50%'}} />
          <div className={styles.connectorDrop} style={{left: '70%'}} />
          <div className={styles.connectorDrop} style={{left: '90%'}} />

          <div className={styles.diagramGrid}>
            {/* Management Account (Root) */}
            <div className={clsx(styles.accountBox, styles.orgRoot)}>
              <LayoutIcon className={styles.accountIcon} size={32} />
              <div className={styles.accountTitle}>Management</div>
              <div className={styles.accountDesc}>AWS Organizations Root</div>
            </div>

            {/* Child Accounts */}
            <div className={styles.accountBox}>
              <Shield className={styles.accountIcon} size={32} />
              <div className={styles.accountTitle}>Security</div>
              <div className={styles.accountDesc}>GuardDuty, Security Hub</div>
            </div>

            <div className={styles.accountBox}>
              <FileText className={styles.accountIcon} size={32} />
              <div className={styles.accountTitle}>Log Archive</div>
              <div className={styles.accountDesc}>CloudTrail, Config</div>
            </div>

            <div className={styles.accountBox}>
              <Network className={styles.accountIcon} size={32} />
              <div className={styles.accountTitle}>Network</div>
              <div className={styles.accountDesc}>Transit Gateway, VPCs</div>
            </div>

            <div className={styles.accountBox}>
              <Settings className={styles.accountIcon} size={32} />
              <div className={styles.accountTitle}>Shared Svcs</div>
              <div className={styles.accountDesc}>CI/CD, ECR, Tooling</div>
            </div>

            <div className={styles.accountBox}>
              <GitBranch className={styles.accountIcon} size={32} />
              <div className={styles.accountTitle}>AFT</div>
              <div className={styles.accountDesc}>Account Factory</div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}

function QuickStartSection() {
  return (
    <section className={styles.quickStart}>
      <div className="container">
        <Heading as="h2" className={styles.sectionTitle}>Get Started in 3 Steps</Heading>
        <div className={styles.stepsGrid}>
          <div className={styles.stepCard}>
            <div className={styles.stepHeader}>
              <div className={styles.stepNumber}>1</div>
              <h3 className={styles.stepTitle}>Clone</h3>
            </div>
            <p>Clone the repository to your local machine to get started.</p>
            <div className={styles.codeBlock}>
              git clone https://github.com/clopca/aws-landing-zone-template.git
            </div>
          </div>

          <div className={styles.stepCard}>
            <div className={styles.stepHeader}>
              <div className={styles.stepNumber}>2</div>
              <h3 className={styles.stepTitle}>Configure</h3>
            </div>
            <p>Set up your environment variables and customize the configuration.</p>
            <div className={styles.codeBlock}>
              ./scripts/setup.sh
            </div>
          </div>

          <div className={styles.stepCard}>
            <div className={styles.stepHeader}>
              <div className={styles.stepNumber}>3</div>
              <h3 className={styles.stepTitle}>Deploy</h3>
            </div>
            <p>Deploy the landing zone using the automated scripts.</p>
            <div className={styles.codeBlock}>
              ./scripts/ralph-loop.sh
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}

export default function Home(): ReactNode {
  const {siteConfig} = useDocusaurusContext();
  return (
    <Layout
      title={`AWS Landing Zone Template`}
      description="Production-ready Terraform template for AWS Organizations">
      <HomepageHeader />
      <main>
        <HomepageFeatures />
        <ArchitectureSection />
        <QuickStartSection />
      </main>
    </Layout>
  );
}

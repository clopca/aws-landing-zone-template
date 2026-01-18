import type {ReactNode} from 'react';
import clsx from 'clsx';
import Link from '@docusaurus/Link';
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';
import Layout from '@theme/Layout';
import HomepageFeatures from '@site/src/components/HomepageFeatures';
import Heading from '@theme/Heading';

import styles from './index.module.css';

function HomepageHeader() {
  const {siteConfig} = useDocusaurusContext();
  return (
    <header className={clsx('hero', styles.heroBanner)}>
      <div className="container">
        <Heading as="h1" className="hero__title">
          Production-Ready AWS Landing Zone
        </Heading>
        <p className="hero__subtitle">
          Deploy a secure, multi-account AWS Organization with Terraform in minutes. 
          Following AWS best practices and Security Reference Architecture.
        </p>
        <div className={styles.buttons}>
          <Link
            className="button button--primary button--lg"
            to="/docs/intro">
            Get Started
          </Link>
          <Link
            className="button button--secondary button--lg"
            to="https://github.com/your-org/aws-landing-zone-template">
            View on GitHub
          </Link>
        </div>
      </div>
    </header>
  );
}

function ArchitectureSection() {
  return (
    <section className="architectureSection">
      <div className="container">
        <Heading as="h2">Enterprise-Grade Architecture</Heading>
        <p>Built on AWS best practices and Security Reference Architecture</p>
        <div className="architectureDiagram">
          {/* Placeholder for architecture diagram - using text for now, could be an image or mermaid */}
          <pre style={{background: 'transparent', border: 'none', color: 'inherit', textAlign: 'left'}}>
{`
                                  +-------------------+
                                  |  AWS Organization |
                                  +---------+---------+
                                            |
        +----------------+------------------+------------------+----------------+
        |                |                  |                  |                |
+-------v------+ +-------v-------+ +--------v-------+ +--------v-------+ +------v-------+
|  Management  | |   Security    | |  Log Archive   | |    Network     | | Shared Svcs  |
| (Org Root)   | | (GuardDuty)   | | (CloudTrail)   | | (Transit GW)   | | (CI/CD)      |
+--------------+ +---------------+ +----------------+ +----------------+ +--------------+
`}
          </pre>
        </div>
      </div>
    </section>
  );
}

function QuickStartSection() {
  return (
    <section className="quickStart">
      <div className="container">
        <Heading as="h2">Get Started in 3 Steps</Heading>
        <div className="steps">
          <div className="stepCard">
            <div className="stepNumber">1</div>
            <div className="stepTitle">Clone</div>
            <div className="codeBlock">git clone https://github.com/...</div>
          </div>
          <div className="stepCard">
            <div className="stepNumber">2</div>
            <div className="stepTitle">Configure</div>
            <div className="codeBlock">cp terraform.tfvars.example ...</div>
          </div>
          <div className="stepCard">
            <div className="stepNumber">3</div>
            <div className="stepTitle">Deploy</div>
            <div className="codeBlock">terraform apply</div>
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

import type {ReactNode} from 'react';
import clsx from 'clsx';
import Heading from '@theme/Heading';
import Translate from '@docusaurus/Translate';
import { 
  Shield, 
  Network, 
  Users, 
  Workflow, 
  CheckCircle, 
  Code2 
} from 'lucide-react';

function FeatureCard({
  icon: Icon,
  color,
  children,
}: {
  icon: React.ElementType;
  color: string;
  children: ReactNode;
}) {
  return (
    <div className="flex flex-col h-full p-6 bg-white dark:bg-[#161b22] rounded-2xl border border-slate-200 dark:border-slate-800 transition-all duration-300 hover:-translate-y-1 hover:shadow-lg hover:border-orange-500/30 group">
      <div className={clsx("flex items-center justify-center w-12 h-12 rounded-xl bg-slate-50 dark:bg-slate-800 mb-4 transition-colors group-hover:bg-white dark:group-hover:bg-[#0d1117] shadow-sm", color)}>
        <Icon size={24} strokeWidth={2} />
      </div>
      {children}
    </div>
  );
}

export default function HomepageFeatures(): ReactNode {
  return (
    <section className="py-24 bg-white dark:bg-[#0d1117]">
      <div className="container mx-auto px-4">
        <div className="text-center max-w-3xl mx-auto mb-16">
          <Heading as="h2" className="text-3xl md:text-4xl font-bold text-slate-900 dark:text-white mb-4">
            <Translate id="homepage.features.title">Everything You Need</Translate>
          </Heading>
          <p className="text-lg text-slate-600 dark:text-slate-400">
            <Translate id="homepage.features.subtitle">
              A complete foundation for your AWS cloud journey, built with modern tools.
            </Translate>
          </p>
        </div>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 lg:gap-8">
          <FeatureCard icon={Users} color="text-blue-500">
            <Heading as="h3" className="text-lg font-bold text-slate-900 dark:text-white mb-2">
              <Translate id="homepage.features.governance.title">Multi-Account Governance</Translate>
            </Heading>
            <p className="text-slate-600 dark:text-slate-400 text-sm leading-relaxed flex-grow">
              <Translate id="homepage.features.governance.desc">
                AWS Organizations with OU structure, Service Control Policies (SCPs), and centralized billing for enterprise-scale management.
              </Translate>
            </p>
          </FeatureCard>

          <FeatureCard icon={Shield} color="text-red-500">
            <Heading as="h3" className="text-lg font-bold text-slate-900 dark:text-white mb-2">
              <Translate id="homepage.features.security.title">Security Baseline</Translate>
            </Heading>
            <p className="text-slate-600 dark:text-slate-400 text-sm leading-relaxed flex-grow">
              <Translate id="homepage.features.security.desc">
                GuardDuty threat detection, Security Hub compliance, AWS Config rules, and IAM Access Analyzer enabled by default.
              </Translate>
            </p>
          </FeatureCard>

          <FeatureCard icon={Network} color="text-green-500">
            <Heading as="h3" className="text-lg font-bold text-slate-900 dark:text-white mb-2">
              <Translate id="homepage.features.network.title">Network Hub</Translate>
            </Heading>
            <p className="text-slate-600 dark:text-slate-400 text-sm leading-relaxed flex-grow">
              <Translate id="homepage.features.network.desc">
                Transit Gateway hub-and-spoke topology with centralized egress/ingress, VPC endpoints, and hybrid connectivity readiness.
              </Translate>
            </p>
          </FeatureCard>

          <FeatureCard icon={Workflow} color="text-orange-500">
            <Heading as="h3" className="text-lg font-bold text-slate-900 dark:text-white mb-2">
              <Translate id="homepage.features.aft.title">Account Factory (AFT)</Translate>
            </Heading>
            <p className="text-slate-600 dark:text-slate-400 text-sm leading-relaxed flex-grow">
              <Translate id="homepage.features.aft.desc">
                Automated account provisioning with GitOps workflow, customizable baselines, and self-service capabilities for teams.
              </Translate>
            </p>
          </FeatureCard>

          <FeatureCard icon={CheckCircle} color="text-teal-500">
            <Heading as="h3" className="text-lg font-bold text-slate-900 dark:text-white mb-2">
              <Translate id="homepage.features.compliance.title">Compliance Ready</Translate>
            </Heading>
            <p className="text-slate-600 dark:text-slate-400 text-sm leading-relaxed flex-grow">
              <Translate id="homepage.features.compliance.desc">
                Aligned with CIS Benchmarks and Security Reference Architecture. Includes audit trails with CloudTrail and evidence collection.
              </Translate>
            </p>
          </FeatureCard>

          <FeatureCard icon={Code2} color="text-purple-500">
            <Heading as="h3" className="text-lg font-bold text-slate-900 dark:text-white mb-2">
              <Translate id="homepage.features.iac.title">Infrastructure as Code</Translate>
            </Heading>
            <p className="text-slate-600 dark:text-slate-400 text-sm leading-relaxed flex-grow">
              <Translate id="homepage.features.iac.desc">
                100% Terraform architecture with modular, reusable components. Designed for CI/CD pipelines and automated testing.
              </Translate>
            </p>
          </FeatureCard>
        </div>
      </div>
    </section>
  );
}

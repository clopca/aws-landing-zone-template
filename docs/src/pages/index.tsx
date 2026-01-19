import type {ReactNode} from 'react';
import clsx from 'clsx';
import Link from '@docusaurus/Link';
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';
import Layout from '@theme/Layout';
import HomepageFeatures from '@site/src/components/HomepageFeatures';
import Heading from '@theme/Heading';
import Translate, {translate} from '@docusaurus/Translate';
import { 
  Layout as LayoutIcon, 
  Shield, 
  FileText, 
  Network, 
  Settings, 
  GitBranch, 
  ArrowRight,
} from 'lucide-react';

function HomepageHeader() {
  return (
    <header className="relative overflow-hidden bg-white dark:bg-[#0d1117] pt-24 pb-20 lg:pt-32 lg:pb-28">
      <div className="absolute inset-0 bg-grid-pattern opacity-[0.6] pointer-events-none" />
      <div className="absolute inset-0 bg-gradient-to-b from-transparent via-transparent to-white/80 dark:to-[#0d1117]/80 pointer-events-none" />
      
      <div className="container relative z-10 mx-auto px-4 text-center">
        <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-orange-50 dark:bg-orange-900/20 border border-orange-200 dark:border-orange-800/30 text-orange-600 dark:text-orange-400 text-sm font-medium mb-8 animate-[fadeInUp_0.6s_ease-out_forwards]">
          <span className="relative flex h-2 w-2">
            <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-orange-400 opacity-75"></span>
            <span className="relative inline-flex rounded-full h-2 w-2 bg-orange-500"></span>
          </span>
          <Translate id="homepage.badge">v1.0 Production Ready</Translate>
        </div>

        <Heading as="h1" className="text-5xl md:text-7xl font-extrabold tracking-tight text-slate-900 dark:text-white mb-6 animate-[fadeInUp_0.8s_ease-out_0.1s_forwards] opacity-0">
          <Translate id="homepage.hero.title.line1">Production-Ready</Translate> <br />
          <span className="text-transparent bg-clip-text bg-gradient-to-r from-orange-500 to-amber-600 dark:from-orange-400 dark:to-amber-500">
            <Translate id="homepage.hero.title.line2">AWS Landing Zone</Translate>
          </span>
        </Heading>
        
        <p className="max-w-2xl mx-auto text-lg md:text-xl text-slate-600 dark:text-slate-400 mb-10 leading-relaxed animate-[fadeInUp_0.8s_ease-out_0.2s_forwards] opacity-0">
          <Translate id="homepage.hero.subtitle">
            Deploy a secure, multi-account AWS Organization with Terraform in minutes. 
            Built on AWS best practices and Security Reference Architecture.
          </Translate>
        </p>
        
        <div className="flex flex-col sm:flex-row items-center justify-center gap-4 animate-[fadeInUp_0.8s_ease-out_0.3s_forwards] opacity-0">
          <Link
            className="group relative inline-flex items-center justify-center px-8 py-3.5 text-base font-bold text-white transition-all duration-200 bg-gradient-to-r from-orange-500 to-orange-600 rounded-lg hover:from-orange-600 hover:to-orange-700 hover:shadow-lg hover:shadow-orange-500/25 hover:-translate-y-0.5 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-orange-500"
            to="/docs/intro">
            <Translate id="homepage.cta.getStarted">Get Started</Translate>
            <ArrowRight className="ml-2 w-5 h-5 transition-transform group-hover:translate-x-1" />
          </Link>
          <Link
            className="inline-flex items-center justify-center px-8 py-3.5 text-base font-bold text-slate-700 dark:text-slate-200 transition-all duration-200 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-lg hover:bg-slate-50 dark:hover:bg-slate-700 hover:border-slate-300 dark:hover:border-slate-600 hover:-translate-y-0.5 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-slate-500"
            to="https://github.com/clopca/aws-landing-zone-template">
            <GitBranch className="mr-2 w-5 h-5" />
            <Translate id="homepage.cta.viewGithub">View on GitHub</Translate>
          </Link>
        </div>
      </div>
    </header>
  );
}

function ArchitectureSection() {
  return (
    <section className="py-24 bg-slate-50 dark:bg-[#0d1117]/50 border-y border-slate-200 dark:border-slate-800">
      <div className="container mx-auto px-4">
        <div className="text-center max-w-3xl mx-auto mb-16">
          <Heading as="h2" className="text-3xl md:text-4xl font-bold text-slate-900 dark:text-white mb-4">
            <Translate id="homepage.architecture.title">Enterprise-Grade Architecture</Translate>
          </Heading>
          <p className="text-lg text-slate-600 dark:text-slate-400">
            <Translate id="homepage.architecture.subtitle">
              A fully automated, multi-account structure designed for security and scalability.
            </Translate>
          </p>
        </div>
        
        <div className="relative max-w-5xl mx-auto p-8 md:p-12 bg-white dark:bg-[#161b22] rounded-3xl border border-slate-200 dark:border-slate-800 shadow-xl dark:shadow-2xl overflow-hidden">
          <div className="absolute inset-0 opacity-[0.03] dark:opacity-[0.05] pointer-events-none" 
               style={{backgroundImage: 'radial-gradient(#64748b 1px, transparent 1px)', backgroundSize: '24px 24px'}}>
          </div>

          <div className="relative grid grid-cols-1 md:grid-cols-3 gap-8">
            <div className="md:col-span-3 flex justify-center mb-8">
              <div className="relative group">
                <div className="absolute -inset-1 bg-gradient-to-r from-orange-500 to-amber-500 rounded-xl blur opacity-25 group-hover:opacity-50 transition duration-200"></div>
                <div className="relative flex items-center gap-4 p-4 bg-white dark:bg-[#0d1117] border border-slate-200 dark:border-slate-700 rounded-xl shadow-sm min-w-[280px]">
                  <div className="p-3 bg-orange-50 dark:bg-orange-900/20 rounded-lg text-orange-600 dark:text-orange-400">
                    <LayoutIcon size={24} />
                  </div>
                  <div>
                    <div className="font-bold text-slate-900 dark:text-white">
                      <Translate id="homepage.architecture.management">Management</Translate>
                    </div>
                    <div className="text-xs text-slate-500 dark:text-slate-400">
                      <Translate id="homepage.architecture.management.desc">Root Account & SCPs</Translate>
                    </div>
                  </div>
                </div>
                <div className="absolute left-1/2 top-full h-8 w-0.5 bg-slate-300 dark:bg-slate-700 -translate-x-1/2 hidden md:block"></div>
              </div>
            </div>

            <div className="relative p-6 rounded-2xl border border-dashed border-slate-300 dark:border-slate-700 bg-slate-50/50 dark:bg-slate-800/20">
              <div className="absolute -top-3 left-4 px-2 bg-white dark:bg-[#161b22] text-xs font-semibold text-slate-500 uppercase tracking-wider">
                <Translate id="homepage.architecture.securityOU">Security OU</Translate>
              </div>
              <div className="space-y-4">
                <div className="flex items-center gap-3 p-3 bg-white dark:bg-[#0d1117] border border-slate-200 dark:border-slate-700 rounded-lg shadow-sm hover:border-orange-500/50 transition-colors">
                  <Shield className="text-blue-500" size={20} />
                  <div>
                    <div className="font-semibold text-sm text-slate-900 dark:text-white">
                      <Translate id="homepage.architecture.security">Security</Translate>
                    </div>
                    <div className="text-[10px] text-slate-500">GuardDuty, Hub</div>
                  </div>
                </div>
                <div className="flex items-center gap-3 p-3 bg-white dark:bg-[#0d1117] border border-slate-200 dark:border-slate-700 rounded-lg shadow-sm hover:border-orange-500/50 transition-colors">
                  <FileText className="text-indigo-500" size={20} />
                  <div>
                    <div className="font-semibold text-sm text-slate-900 dark:text-white">
                      <Translate id="homepage.architecture.logArchive">Log Archive</Translate>
                    </div>
                    <div className="text-[10px] text-slate-500">CloudTrail, Config</div>
                  </div>
                </div>
              </div>
            </div>

            <div className="relative p-6 rounded-2xl border border-dashed border-slate-300 dark:border-slate-700 bg-slate-50/50 dark:bg-slate-800/20">
              <div className="absolute -top-3 left-4 px-2 bg-white dark:bg-[#161b22] text-xs font-semibold text-slate-500 uppercase tracking-wider">
                <Translate id="homepage.architecture.infraOU">Infrastructure OU</Translate>
              </div>
              <div className="space-y-4">
                <div className="flex items-center gap-3 p-3 bg-white dark:bg-[#0d1117] border border-slate-200 dark:border-slate-700 rounded-lg shadow-sm hover:border-orange-500/50 transition-colors">
                  <Network className="text-green-500" size={20} />
                  <div>
                    <div className="font-semibold text-sm text-slate-900 dark:text-white">
                      <Translate id="homepage.architecture.network">Network</Translate>
                    </div>
                    <div className="text-[10px] text-slate-500">TGW, VPCs</div>
                  </div>
                </div>
                <div className="flex items-center gap-3 p-3 bg-white dark:bg-[#0d1117] border border-slate-200 dark:border-slate-700 rounded-lg shadow-sm hover:border-orange-500/50 transition-colors">
                  <Settings className="text-slate-500" size={20} />
                  <div>
                    <div className="font-semibold text-sm text-slate-900 dark:text-white">
                      <Translate id="homepage.architecture.sharedSvcs">Shared Svcs</Translate>
                    </div>
                    <div className="text-[10px] text-slate-500">CI/CD, Tooling</div>
                  </div>
                </div>
              </div>
            </div>

            <div className="relative p-6 rounded-2xl border border-dashed border-slate-300 dark:border-slate-700 bg-slate-50/50 dark:bg-slate-800/20">
              <div className="absolute -top-3 left-4 px-2 bg-white dark:bg-[#161b22] text-xs font-semibold text-slate-500 uppercase tracking-wider">
                <Translate id="homepage.architecture.workloadsOU">Workloads OU</Translate>
              </div>
              <div className="space-y-4">
                <div className="flex items-center gap-3 p-3 bg-white dark:bg-[#0d1117] border border-slate-200 dark:border-slate-700 rounded-lg shadow-sm hover:border-orange-500/50 transition-colors">
                  <GitBranch className="text-orange-500" size={20} />
                  <div>
                    <div className="font-semibold text-sm text-slate-900 dark:text-white">AFT</div>
                    <div className="text-[10px] text-slate-500">
                      <Translate id="homepage.architecture.aft.desc">Account Factory</Translate>
                    </div>
                  </div>
                </div>
                <div className="flex items-center justify-center p-3 border border-dashed border-slate-300 dark:border-slate-700 rounded-lg text-slate-400 text-xs">
                  <Translate id="homepage.architecture.vendedAccounts">+ Vended Accounts</Translate>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}

function QuickStartSection() {
  return (
    <section className="py-24 bg-white dark:bg-[#0d1117]">
      <div className="container mx-auto px-4">
        <div className="text-center mb-16">
          <Heading as="h2" className="text-3xl md:text-4xl font-bold text-slate-900 dark:text-white mb-4">
            <Translate id="homepage.quickstart.title">Get Started in 3 Steps</Translate>
          </Heading>
          <p className="text-lg text-slate-600 dark:text-slate-400">
            <Translate id="homepage.quickstart.subtitle">From zero to deployed landing zone in less than an hour.</Translate>
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-8 max-w-6xl mx-auto">
          <div className="group relative bg-slate-50 dark:bg-[#161b22] rounded-2xl p-8 border border-slate-200 dark:border-slate-800 hover:border-orange-500/30 transition-all duration-300 hover:-translate-y-1 hover:shadow-xl">
            <div className="absolute -top-4 -left-4 w-12 h-12 bg-gradient-to-br from-orange-500 to-amber-600 rounded-xl flex items-center justify-center text-white font-bold text-xl shadow-lg shadow-orange-500/20">1</div>
            <h3 className="text-xl font-bold text-slate-900 dark:text-white mb-4 mt-2">
              <Translate id="homepage.quickstart.step1.title">Clone Repository</Translate>
            </h3>
            <p className="text-slate-600 dark:text-slate-400 mb-6 text-sm">
              <Translate id="homepage.quickstart.step1.desc">
                Clone the template to your local machine to get started with the infrastructure code.
              </Translate>
            </p>
            <div className="bg-[#0d1117] rounded-lg p-4 border border-slate-800 font-mono text-xs text-slate-300 overflow-x-auto">
              <div className="flex gap-2 mb-2">
                <div className="w-2.5 h-2.5 rounded-full bg-red-500"></div>
                <div className="w-2.5 h-2.5 rounded-full bg-yellow-500"></div>
                <div className="w-2.5 h-2.5 rounded-full bg-green-500"></div>
              </div>
              <span className="text-green-400">$</span> git clone https://github.com/clopca/aws-landing-zone-template.git
            </div>
          </div>

          <div className="group relative bg-slate-50 dark:bg-[#161b22] rounded-2xl p-8 border border-slate-200 dark:border-slate-800 hover:border-orange-500/30 transition-all duration-300 hover:-translate-y-1 hover:shadow-xl">
            <div className="absolute -top-4 -left-4 w-12 h-12 bg-gradient-to-br from-orange-500 to-amber-600 rounded-xl flex items-center justify-center text-white font-bold text-xl shadow-lg shadow-orange-500/20">2</div>
            <h3 className="text-xl font-bold text-slate-900 dark:text-white mb-4 mt-2">
              <Translate id="homepage.quickstart.step2.title">Configure</Translate>
            </h3>
            <p className="text-slate-600 dark:text-slate-400 mb-6 text-sm">
              <Translate id="homepage.quickstart.step2.desc">
                Run the setup script to initialize your environment and install dependencies.
              </Translate>
            </p>
            <div className="bg-[#0d1117] rounded-lg p-4 border border-slate-800 font-mono text-xs text-slate-300 overflow-x-auto">
              <div className="flex gap-2 mb-2">
                <div className="w-2.5 h-2.5 rounded-full bg-red-500"></div>
                <div className="w-2.5 h-2.5 rounded-full bg-yellow-500"></div>
                <div className="w-2.5 h-2.5 rounded-full bg-green-500"></div>
              </div>
              <span className="text-green-400">$</span> ./scripts/setup.sh
            </div>
          </div>

          <div className="group relative bg-slate-50 dark:bg-[#161b22] rounded-2xl p-8 border border-slate-200 dark:border-slate-800 hover:border-orange-500/30 transition-all duration-300 hover:-translate-y-1 hover:shadow-xl">
            <div className="absolute -top-4 -left-4 w-12 h-12 bg-gradient-to-br from-orange-500 to-amber-600 rounded-xl flex items-center justify-center text-white font-bold text-xl shadow-lg shadow-orange-500/20">3</div>
            <h3 className="text-xl font-bold text-slate-900 dark:text-white mb-4 mt-2">
              <Translate id="homepage.quickstart.step3.title">Deploy</Translate>
            </h3>
            <p className="text-slate-600 dark:text-slate-400 mb-6 text-sm">
              <Translate id="homepage.quickstart.step3.desc">
                Launch the Ralph loop to autonomously deploy your landing zone components.
              </Translate>
            </p>
            <div className="bg-[#0d1117] rounded-lg p-4 border border-slate-800 font-mono text-xs text-slate-300 overflow-x-auto">
              <div className="flex gap-2 mb-2">
                <div className="w-2.5 h-2.5 rounded-full bg-red-500"></div>
                <div className="w-2.5 h-2.5 rounded-full bg-yellow-500"></div>
                <div className="w-2.5 h-2.5 rounded-full bg-green-500"></div>
              </div>
              <span className="text-green-400">$</span> ./scripts/ralph-loop.sh
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}

export default function Home(): ReactNode {
  return (
    <Layout
      title={translate({id: 'homepage.title', message: 'AWS Landing Zone Template'})}
      description={translate({id: 'homepage.description', message: 'Production-ready Terraform template for AWS Organizations'})}>
      <div id="tw-scope">
        <HomepageHeader />
        <main>
          <HomepageFeatures />
          <ArchitectureSection />
          <QuickStartSection />
        </main>
      </div>
    </Layout>
  );
}

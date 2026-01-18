import type {SidebarsConfig} from '@docusaurus/plugin-content-docs';

// This runs in Node.js - Don't use client-side code here (browser APIs, JSX...)

/**
 * Creating a sidebar enables you to:
 - create an ordered group of docs
 - render a sidebar for each doc of that group
 - provide next/previous navigation

 The sidebars can be generated from the filesystem, or explicitly defined here.

 Create as many sidebars as you want.
 */
const sidebars: SidebarsConfig = {
  // AWS Landing Zone documentation sidebar
  landingZoneSidebar: [
    'intro',
    {
      type: 'category',
      label: 'Architecture',
      items: [
        'architecture/overview',
        'architecture/multi-account',
        'architecture/security-model',
        'architecture/network-design',
        'architecture/iam-strategy',
        'architecture/cost-governance',
        'architecture/data-protection',
        'architecture/compliance-mapping',
      ],
    },
    {
      type: 'category',
      label: 'Modules',
      items: [
        'modules/organization',
        'modules/security-baseline',
        'modules/networking',
        'modules/log-archive',
        'modules/shared-services',
        'modules/aft',
      ],
    },
    {
      type: 'category',
      label: 'Runbooks',
      items: [
        'runbooks/account-vending',
        'runbooks/deployment',
        'runbooks/cicd-setup',
        'runbooks/troubleshooting',
      ],
    },
  ],
};

export default sidebars;

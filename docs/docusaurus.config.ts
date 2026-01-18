import {themes as prismThemes} from 'prism-react-renderer';
import type {Config} from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';

const SITE_URL = process.env.SITE_URL || 'https://landing-zone.example.com';
const GITHUB_ORG = process.env.GITHUB_ORG || 'your-org';
const GITHUB_REPO = process.env.GITHUB_REPO || 'aws-landing-zone-template';
const COPYRIGHT_HOLDER = process.env.COPYRIGHT_HOLDER || 'Your Organization';

const config: Config = {
  title: 'AWS Landing Zone Template',
  tagline: 'Multi-Account AWS Organization with Terraform',
  favicon: 'img/favicon.ico',

  future: {
    v4: true,
  },

  url: SITE_URL,
  baseUrl: '/',

  organizationName: GITHUB_ORG,
  projectName: GITHUB_REPO,

  onBrokenLinks: 'throw',

  // Even if you don't use internationalization, you can use this field to set
  // useful metadata like html lang. For example, if your site is Chinese, you
  // may want to replace "en" with "zh-Hans".
  i18n: {
    defaultLocale: 'en',
    locales: ['en', 'es'],
    localeConfigs: {
      en: {
        htmlLang: 'en-US',
        label: 'English',
      },
      es: {
        htmlLang: 'es-ES',
        label: 'Español',
      },
    },
  },

  presets: [
    [
      'classic',
      {
        docs: {
          sidebarPath: './sidebars.ts',
          editUrl: `https://github.com/${GITHUB_ORG}/${GITHUB_REPO}/edit/main/docs/`,
        },
        blog: {
          showReadingTime: true,
          feedOptions: {
            type: ['rss', 'atom'],
            xslt: true,
          },
          editUrl: `https://github.com/${GITHUB_ORG}/${GITHUB_REPO}/edit/main/docs/`,
          onInlineTags: 'warn',
          onInlineAuthors: 'warn',
          onUntruncatedBlogPosts: 'warn',
        },
        theme: {
          customCss: './src/css/custom.css',
        },
      } satisfies Preset.Options,
    ],
  ],
  themes: ['@docusaurus/theme-mermaid'],

  themeConfig: {
    image: 'img/aws-landing-zone-social-card.jpg',
    colorMode: {
      respectPrefersColorScheme: true,
    },
    navbar: {
      title: 'AWS Landing Zone',
      logo: {
        alt: 'AWS Landing Zone Logo',
        src: 'img/logo.svg',
      },
      items: [
        {
          type: 'docSidebar',
          sidebarId: 'landingZoneSidebar',
          position: 'left',
          label: 'Documentation',
        },
        {to: '/blog', label: 'Blog', position: 'left'},
        {
          type: 'localeDropdown',
          position: 'right',
        },
        {
          href: `https://github.com/${GITHUB_ORG}/${GITHUB_REPO}`,
          label: 'GitHub',
          position: 'right',
        },
      ],
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: 'Documentation',
          items: [
            {
              label: 'Getting Started',
              to: '/docs/intro',
            },
            {
              label: 'Architecture',
              to: '/docs/architecture/overview',
            },
            {
              label: 'Modules',
              to: '/docs/modules/organization',
            },
          ],
        },
        {
          title: 'Resources',
          items: [
            {
              label: 'AWS Organizations',
              href: 'https://docs.aws.amazon.com/organizations/',
            },
            {
              label: 'Terraform',
              href: 'https://www.terraform.io/',
            },
            {
              label: 'Account Factory for Terraform',
              href: 'https://docs.aws.amazon.com/controltower/latest/userguide/aft.html',
            },
          ],
        },
        {
          title: 'Community',
          items: [
            {
              label: 'GitHub',
              href: `https://github.com/${GITHUB_ORG}/${GITHUB_REPO}`,
            },
            {
              label: 'Issues',
              href: `https://github.com/${GITHUB_ORG}/${GITHUB_REPO}/issues`,
            },
          ],
        },
      ],
      copyright: `Copyright © ${new Date().getFullYear()} ${COPYRIGHT_HOLDER}. Built with Docusaurus.`,
    },
    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
      additionalLanguages: ['hcl', 'bash', 'json', 'yaml'],
    },
  } satisfies Preset.ThemeConfig,
};

export default config;

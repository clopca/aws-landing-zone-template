# AWS Landing Zone Documentation

This documentation site is built using [Docusaurus](https://docusaurus.io/) and deployed to AWS CloudFront via [SST](https://sst.dev/).

## Installation

```bash
pnpm install
```

## Local Development

```bash
pnpm start
```

This command starts a local development server and opens a browser window. Most changes are reflected live without having to restart the server.

## Build

```bash
pnpm build
```

This generates static content into the `build` directory.

## Deployment

Deploy to AWS using SST (from the repository root):

```bash
./scripts/docs-deploy.sh dev      # Deploy to dev stage
./scripts/docs-deploy.sh staging  # Deploy to staging stage
./scripts/docs-deploy.sh prod     # Deploy to production
```

Or manually:

```bash
cd ../infra
pnpm exec sst deploy --stage dev
```

## Internationalization

This site supports multiple languages:
- English (default)
- Spanish (`/es/`)

To add translations, edit files in `i18n/es/`.

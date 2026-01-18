/// <reference path="./.sst/platform/config.d.ts" />

/**
 * SST Configuration for AWS Landing Zone Documentation
 * 
 * This configuration deploys the Docusaurus documentation site to AWS
 * using S3 for storage and CloudFront for CDN distribution.
 * 
 * Usage:
 *   Development: npx sst dev
 *   Deploy:      npx sst deploy --stage <stage>
 *   Remove:      npx sst remove --stage <stage>
 * 
 * Stages:
 *   - dev: Development environment
 *   - staging: Staging environment
 *   - prod: Production environment
 */

export default $config({
  app(input) {
    return {
      name: "aws-landing-zone-docs",
      removal: input?.stage === "prod" ? "retain" : "remove",
      protect: ["prod"].includes(input?.stage ?? ""),
      home: "aws",
      providers: {
        aws: {
          // Region can be overridden via AWS_REGION env var
          region: "us-east-1",
          // Profile can be specified per stage
          // profile: input?.stage === "prod" ? "prod-profile" : "dev-profile"
        },
      },
    };
  },

  async run() {
    // Documentation site
    const docs = new sst.aws.StaticSite("Docs", {
      path: "../docs",
      build: {
        command: "npm run build",
        output: "build",
      },
      // Custom domain configuration (uncomment and configure for production)
      // domain: {
      //   name: $app.stage === "prod" 
      //     ? "docs.your-domain.com" 
      //     : `docs-${$app.stage}.your-domain.com`,
      //   // If using Route53, SST will automatically create the certificate
      //   // For external DNS, you'll need to configure DNS records manually
      // },
      
      // Environment variables passed to the build process
      environment: {
        // Docusaurus environment variables
        DOCUSAURUS_ENV: $app.stage,
      },
      
      // Asset configuration
      assets: {
        // Cache static assets for 1 year
        fileOptions: [
          {
            files: ["**/*.js", "**/*.css", "**/*.woff2"],
            cacheControl: "max-age=31536000,public,immutable",
          },
          {
            files: "**/*.html",
            cacheControl: "max-age=0,no-cache,no-store,must-revalidate",
          },
        ],
      },
      
      // Error pages
      errorPage: "404.html",
    });

    // Output the site URL
    return {
      docsUrl: docs.url,
      // If custom domain is configured:
      // docsCustomUrl: docs.customDomainUrl,
    };
  },
});

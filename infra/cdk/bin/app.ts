#!/usr/bin/env node
import 'source-map-support/register';
import * as cdk from 'aws-cdk-lib';
import { CloudFrontStack } from '../lib/cloudfront-stack';
import { loadConfig } from '../lib/config';

const app = new cdk.App();
const { env, config } = loadConfig(app);

new CloudFrontStack(app, `sirgrimorum-${env}-cloudfront`, {
  env: { account: config.account, region: config.region },
  domain: config.domain,
  marketingBucketName: config.terraform.marketingBucketName,
  marketingBucketArn: config.terraform.marketingBucketArn,
  cloudfrontCertArn: config.terraform.cloudfrontCertArn,
});

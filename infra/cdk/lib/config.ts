import { App } from 'aws-cdk-lib';

export interface SirgrimorumConfig {
  account: string;
  region: string;
  domain: string;
  terraform: {
    marketingBucketName: string;
    marketingBucketArn: string;
    cloudfrontCertArn: string;
  };
}

export function loadConfig(app: App): { env: string; config: SirgrimorumConfig } {
  const env = app.node.tryGetContext('sirgrimorum:env') || 'prod';
  const config = app.node.tryGetContext(`sirgrimorum:${env}`) as SirgrimorumConfig;

  if (!config) {
    throw new Error(`Missing context for sirgrimorum:${env}`);
  }

  return { env, config };
}

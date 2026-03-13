import * as cdk from 'aws-cdk-lib';
import * as cloudfront from 'aws-cdk-lib/aws-cloudfront';
import * as origins from 'aws-cdk-lib/aws-cloudfront-origins';
import * as s3 from 'aws-cdk-lib/aws-s3';
import * as acm from 'aws-cdk-lib/aws-certificatemanager';
import { Construct } from 'constructs';

interface CloudFrontStackProps extends cdk.StackProps {
  domain: string;
  marketingBucketName: string;
  marketingBucketArn: string;
  cloudfrontCertArn: string;
}

export class CloudFrontStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props: CloudFrontStackProps) {
    super(scope, id, props);

    const bucket = s3.Bucket.fromBucketAttributes(this, 'MarketingBucket', {
      bucketName: props.marketingBucketName,
      bucketArn: props.marketingBucketArn,
    });

    const certificate = acm.Certificate.fromCertificateArn(
      this,
      'Certificate',
      props.cloudfrontCertArn,
    );

    // www -> non-www redirect + index.html rewrite for Astro static output
    const urlRewriteFunction = new cloudfront.Function(this, 'UrlRewrite', {
      code: cloudfront.FunctionCode.fromInline(`
function handler(event) {
  var request = event.request;
  var host = request.headers.host.value;

  if (host.startsWith('www.')) {
    return {
      statusCode: 301,
      statusDescription: 'Moved Permanently',
      headers: {
        location: { value: 'https://${props.domain}' + request.uri }
      }
    };
  }

  if (request.uri.endsWith('/')) {
    request.uri += 'index.html';
  } else if (!request.uri.includes('.')) {
    request.uri += '/index.html';
  }

  return request;
}
      `.trim()),
    });

    const distribution = new cloudfront.Distribution(this, 'Distribution', {
      domainNames: [props.domain, `www.${props.domain}`],
      certificate,
      defaultRootObject: 'index.html',
      defaultBehavior: {
        origin: origins.S3BucketOrigin.withOriginAccessControl(bucket),
        viewerProtocolPolicy: cloudfront.ViewerProtocolPolicy.REDIRECT_TO_HTTPS,
        functionAssociations: [
          {
            function: urlRewriteFunction,
            eventType: cloudfront.FunctionEventType.VIEWER_REQUEST,
          },
        ],
      },
      errorResponses: [
        {
          httpStatus: 403,
          responseHttpStatus: 200,
          responsePagePath: '/index.html',
        },
        {
          httpStatus: 404,
          responseHttpStatus: 404,
          responsePagePath: '/404.html',
        },
      ],
    });

    new cdk.CfnOutput(this, 'DistributionDomainName', {
      value: distribution.distributionDomainName,
    });

    new cdk.CfnOutput(this, 'DistributionArn', {
      value: `arn:aws:cloudfront::${this.account}:distribution/${distribution.distributionId}`,
    });

    new cdk.CfnOutput(this, 'DistributionId', {
      value: distribution.distributionId,
    });
  }
}

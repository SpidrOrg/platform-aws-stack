const route53HostedZoneConfig = require("../values/route53HostedZoneConfig.json");
const getAWSAccountAndRegion = require("../getAWSAccountAndRegion.js");
const { Stack, Duration } = require('aws-cdk-lib');
const route53 = require("aws-cdk-lib/aws-route53");
const s3 = require("aws-cdk-lib/aws-s3");
const dynamodb = require("aws-cdk-lib/aws-dynamodb");
const s3deploy = require("aws-cdk-lib/aws-s3-deployment");
const path = require("path");
class PreRequisitesStack extends Stack {
  constructor(scope, id, props) {
    super(scope, id, props);
    const {awsAccount, awsRegion} = getAWSAccountAndRegion();

    // Step 1: Create S3 Bucket
    new s3.Bucket(this, 'terraformStateFileS3Bucket', {
      bucketName: `${awsAccount}-statefile`
    });

    // Step 2:
    new dynamodb.Table(this, 'terraformStatelockDynamoDB', {
      partitionKey: { name: 'LockID ', type: dynamodb.AttributeType.STRING },
      tableName: "tf-statelock"
    });

    // Step 3:
    const lamdaFunctionCodebaseBucketName = `${awsAccount}-codebase`
    const codebaseBucket = new s3.Bucket(this, 'terraformLambdasS3Bucket', {
      bucketName: lamdaFunctionCodebaseBucketName
    });

    // Step 3a: Create bucket folders
    new s3deploy.BucketDeployment(this, `client-bucket-folders-${lamdaFunctionCodebaseBucketName}`, {
      sources: [s3deploy.Source.asset(path.join(__dirname, '../values/s3-codebase-bucket-folders'))],
      destinationBucket: codebaseBucket,
    });

    Object.keys(route53HostedZoneConfig).forEach((hostedZoneName)=>{
      const hostedZoneConfig = route53HostedZoneConfig[hostedZoneName];
      const hostedZone = new route53.PublicHostedZone(this, `HostedZone${hostedZoneName}`, {
        zoneName: hostedZoneName,
      });

      Object.keys(hostedZoneConfig).forEach((recordName)=>{
        const recordValues = hostedZoneConfig[recordName];
        new route53.NsRecord(this, `NSRecord-${hostedZoneName}${recordName}`, {
          zone: hostedZone,
          recordName: `${recordName}`,
          values: recordValues
        });
      })
    })
  }
}

module.exports = { PreRequisitesStack }

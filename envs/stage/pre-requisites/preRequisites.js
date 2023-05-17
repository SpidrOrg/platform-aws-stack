const { exec } = require('node:child_process')
const path = require("path");

// This
// const indexOfAwsAccountInArnSplit = process.env.CODEBUILD_BUILD_ARN.split(":").indexOf(process.env.AWS_REGION) + 1;
// const awsAccount = process.env.CODEBUILD_BUILD_ARN.split(":")[indexOfAwsAccountInArnSplit];
// const awsRegion = process.env.AWS_REGION;
// or this//
const awsAccount = "319925118739";
const awsRegion = "us-east-1";

const {awsAccount, awsRegion} = getAWSAccountAndRegion();

const stateFileBucketName = `${awsAccount}-statefile`;
exec(`aws s3api create-bucket --bucket ${stateFileBucketName}  --region us-east-1`, (err, output)=>{
  if (err){
    console.log(`Error creating bucket ${stateFileBucketName}`, err);
    return
  }
  console.log(`Successfully created ${stateFileBucketName}`, output);
});

//
const dynamoDBTableName = "tf-statelock";
exec(`aws dynamodb create-table --table-name ${dynamoDBTableName} --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1`, (err, output)=>{
  if (err){
    console.log(`Error creating Dynamodb table ${dynamoDBTableName}`, err);
    return
  }
  console.log(`Successfully created Dynamodb table ${dynamoDBTableName}`, output);
});

//
const codebaseBucketName = `${awsAccount}-codebase`;
exec(`aws s3api create-bucket --bucket ${codebaseBucketName}  --region us-east-1`, (err, output)=>{
  if (err){
    console.log(`Error creating bucket ${codebaseBucketName}`, err);
    return
  }
  console.log(`Successfully created ${codebaseBucketName}`, output);
  const codebaseFolderStructrueDirectoryPath = path.join("./values/s3-codebase-bucket-folders")
  exec(`aws s3 cp ${codebaseFolderStructrueDirectoryPath} s3://${codebaseBucketName}/ --recursive `, (err, output)=>{
    if (err){
      console.log(`Error copying to codebase bucket ${codebaseBucketName}`, err);
      return
    }
    console.log(`Successfully copied to codebase bucket ${codebaseBucketName}`, output);
  });
});



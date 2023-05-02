# Terraform Script to create S3 bucket with VPC Endpoint

## Resources Created

* S3 bucket 
* S3 with VPC endpoint  
* ACL, Tags and s3 bucket configuration
* aws_s3_bucket_metric


## Best Practices

* S3 with VPC endpoint
* S3 versioning
* Lifecycle rules
* Server-side encryption	
* S3 access logging
* object locking


## Module reference

https://github.com/terraform-aws-modules/terraform-aws-s3-bucket/tree/v2.6.0

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| <a name="input_region_name"></a> [region\_name](#input\region\_name) | Region name | `string` | `[]`
| <a name="input_bucket_Name"></a> [bucket\_name](#input\_bucket\_name) | The name of the bucket. and name should be unique name. | `string` | `[]` |
| <a name="input_force_destroy"></a> [force\_destroy](#force\_destroy) | Forcefully delete the bucket which had a objects | `bool` | `true` 
| <a name="input_attach_policy"></a> [attach\_policy](#input\attach\_policy) | Controls if S3 bucket should have bucket policy attached -true/false | `bool` | `[]`
| <a name="input_deny_insecure"></a> [deny\_insecure](#deny\_insecure) | Attach_deny_insecure_transport_policy | `bool` | `true`
| <a name="input_versioning"></a> [versioning](#versioning) | versioning on S3 bucket | `bool` | `true` 
| <a name="input_project"></a> [project](#input\_project) | Name of the project for which s3 bucket is provisioned (needed for tagging) | `string` | `[]`
| <a name="input_environment_class"></a> [environment_class](#input\_environment_class) | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `[]`
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#kms\_key\_arn) | Enter amazone KMS key arn | `string` | `[]`
| <a name="input_object_lock"></a> [object\_lock](#input\_object\_lock) | If you want to 'enabled' object lock default its 'Disabled'| `string` | `[]`
| <a name="input_lifecycle_rule_enabled"></a> [lifecycle\_rule\_enabled](#lifecycle\_rule\_enabled) | Enter lifecycle_rule prefix | `bool` | `false`
| <a name="input_lifecycle_rule_prefix"></a> [lifecycle\_rule\_prefix](#lifecycle\_rule\_prefix) | Enter lifecycle_rule prefix | `string` | `log`
| <a name="input_current_transition"></a> [current\_transition](#current\_transition) | provide current_transition components(Days and storage_class) | `any` | ``
| <a name="input_expiration_days"></a> [expiration\_days](#expiration\_days) | Enter the expiration_days | `number` | `30`
| <a name="input_noncurrent_version_expiration_days"></a> [noncurrent\_version\_expiration\_days](#noncurrent\_version\_expiration\_days) | Enter the noncurrent_version_expiration_days | `number` | `300`
| <a name="input_abort_incomplete_multipart_upload_days"></a> [abort\_incomplete\_multipart\_upload\_days](#abort\_incomplete\_multipart\_upload\_days) | Number of days to abort_incomplete_multipart_upload_days | `number` | `7`
| <a name="input_noncurrent_version_transition"></a> [noncurrent\_version\_transition](#noncurrent\_version\_transition) | provide noncurrent_version_transition components(Days and storage_class) | `any` | ``
| <a name="input_block_public_acls"></a> [block\_public\_acls](#block\_public\_acls) |If you dont want to block_public_acls set 'false' but it should be 'true'| `bool` | `true`
| <a name="input_block_public_policy"></a> [block\_public\_policy](#block\_public\_policy) | If you dont want to block_public_policy set 'false' but it should be 'true' | `bool` | `true`
| <a name="input_ignore_public_acls"></a> [ignore\_public\_acls](#ignore\_public\_acls) | If you dont want to ignore_public_acls set 'false' but it should be 'true' | `bool` | `true`
| <a name="input_restrict_public_buckets"></a> [restrict\_public\_buckets](#restrict\_public\_buckets) | If you dont want to restrict_public_buckets set 'false' but it should be 'true' | `bool` | `true`
| <a name="input_vpc_id"></a> [vpc\_id](#input\vpc\_id) | vpc id to configure endpoint | `string` | `[]`
| <a name="input_vpc_endpoint_name"></a> [vpc\_endpoint\_name](#input\_vpc\_endpoint\_name) | Name of the VPC endpoint (needed for tagging) | `string` | `[]`
| <a name="input_route_table_id"></a> [route\_table\_id](#input\route\_table\_id) | route table id to configure to associate with endpoint | `string` | `[]`



## Outputs

| Name | Description |
|------|-------------|
| <a name="output_s3_bucket_arn"></a> [s3_bucket\_arn](#output\s3_bucket\_arn) | Amazon Resource Name (ARN) of the s3 bucket |
| <a name="output_vpc_endpoint_arn"></a> [vpc_endpoint\_arn](#output\vpc_endpoint\_arn) | Amazon Resource Name (ARN) of the vpc endpoint |
| <a name="output_33_bucket_id"></a> [s3_bucket\_id](#output\s3_bucket\_id) | Amazon s3 bucket id|
| <a name="output_s3_bucket_bucket_domain_name"></a> [s3_bucket\_bucket\_domain\_name](#output\bucket_domain\_Name) |Amazon s3_bucket_bucket_domain_name|



<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.26 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.36 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.36 |
| <a name="provider_aws.replica"></a> [aws.replica](#provider\_aws.replica) | >= 3.36 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_log-replica_bucket"></a> [log-replica\_bucket](#module\_log-replica\_bucket) | ./modules/terraform-aws-s3-bucket-2.14.1 | n/a |
| <a name="module_log_bucket"></a> [log\_bucket](#module\_log\_bucket) | ./modules/terraform-aws-s3-bucket-2.14.1 | n/a |
| <a name="module_object_locked"></a> [object\_locked](#module\_object\_locked) | ./modules/terraform-aws-s3-bucket-2.14.1 | n/a |
| <a name="module_replica_bucket"></a> [replica\_bucket](#module\_replica\_bucket) | ./modules/terraform-aws-s3-bucket-2.14.1 | n/a |
| <a name="module_s3_bucket"></a> [s3\_bucket](#module\_s3\_bucket) | ./modules/terraform-aws-s3-bucket-2.14.1 | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.replication_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy_attachment.replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_policy_attachment.replication_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_role.replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.replication_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.s3-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_kms_key.replica](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_s3_bucket_metric.metrics](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_metric) | resource |
| [aws_vpc_endpoint.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint_route_table_association.route_table_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_route_table_association) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_abort_incomplete_multipart_upload_days"></a> [abort\_incomplete\_multipart\_upload\_days](#input\_abort\_incomplete\_multipart\_upload\_days) | Number of days to abort incomplete multipart upload | `number` | `7` | no |
| <a name="input_assume_role_arn"></a> [assume\_role\_arn](#input\_assume\_role\_arn) | Assume role in which account to create | `string` | `""` | no |
| <a name="input_attach_policy"></a> [attach\_policy](#input\_attach\_policy) | Controls if S3 bucket should have bucket policy attached (set to `true` to use value of `policy` as bucket policy) | `bool` | `true` | no |
| <a name="input_block_public_acls"></a> [block\_public\_acls](#input\_block\_public\_acls) | Whether Amazon S3 should block public ACLs for this bucket. | `bool` | `true` | no |
| <a name="input_block_public_policy"></a> [block\_public\_policy](#input\_block\_public\_policy) | Whether Amazon S3 should block public bucket policies for this bucket. | `bool` | `true` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Provide S3-bucket name | `string` | n/a | yes |
| <a name="input_current_transition"></a> [current\_transition](#input\_current\_transition) | Specify the current transition | <pre>list(object({<br>    days          = number<br>    storage_class = string<br>  }))</pre> | <pre>[<br>  {<br>    "days": 30,<br>    "storage_class": "ONEZONE_IA"<br>  },<br>  {<br>    "days": 60,<br>    "storage_class": "GLACIER"<br>  }<br>]</pre> | no |
| <a name="input_deny_insecure"></a> [deny\_insecure](#input\_deny\_insecure) | Controls if S3 bucket should have deny non-SSL transport policy attached | `bool` | `true` | no |
| <a name="input_disable_server_side_encryption"></a> [disable\_server\_side\_encryption](#input\_disable\_server\_side\_encryption) | Whether server side encryption should be disabled or not | `bool` | `false` | no |
| <a name="input_enable_replication"></a> [enable\_replication](#input\_enable\_replication) | Whether replication should be enabled for s3 bucket or not | `bool` | `true` | no |
| <a name="input_environment_class"></a> [environment\_class](#input\_environment\_class) | Environment of the bucket (e.g dev, uat, prod) | `string` | n/a | yes |
| <a name="input_expiration_days"></a> [expiration\_days](#input\_expiration\_days) | Enter the expiration days for current transition | `number` | `30` | no |
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | Add extra tags to your resource | `map(string)` | `{}` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable | `bool` | `true` | no |
| <a name="input_ignore_public_acls"></a> [ignore\_public\_acls](#input\_ignore\_public\_acls) | Whether Amazon S3 should ignore public ACLs for this bucket. | `bool` | `true` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | Enter AWS KMS key arn for server side encryption | `string` | `null` | no |
| <a name="input_lifecycle_rule_enabled"></a> [lifecycle\_rule\_enabled](#input\_lifecycle\_rule\_enabled) | If you need to enable lifecycle rule set 'true', default its false | `bool` | `false` | no |
| <a name="input_lifecycle_rule_prefix"></a> [lifecycle\_rule\_prefix](#input\_lifecycle\_rule\_prefix) | Enter lifecycle rule prefix | `string` | `"log"` | no |
| <a name="input_log_bucket"></a> [log\_bucket](#input\_log\_bucket) | If you want log bucket put as true | `bool` | `false` | no |
| <a name="input_metrics"></a> [metrics](#input\_metrics) | The s3 bucket metrics you want to create | <pre>list(object({<br>    name   = string<br>    prefix = string<br>    tags   = map(string)<br>  }))</pre> | `[]` | no |
| <a name="input_noncurrent_version_expiration_days"></a> [noncurrent\_version\_expiration\_days](#input\_noncurrent\_version\_expiration\_days) | Enter the noncurrent version expiration days | `number` | `30` | no |
| <a name="input_noncurrent_version_transition"></a> [noncurrent\_version\_transition](#input\_noncurrent\_version\_transition) | specify the non-current version transition | <pre>list(object({<br>    days          = number<br>    storage_class = string<br>  }))</pre> | <pre>[<br>  {<br>    "days": 30,<br>    "storage_class": "STANDARD_IA"<br>  },<br>  {<br>    "days": 60,<br>    "storage_class": "ONEZONE_IA"<br>  },<br>  {<br>    "days": 90,<br>    "storage_class": "GLACIER"<br>  }<br>]</pre> | no |
| <a name="input_object_lock"></a> [object\_lock](#input\_object\_lock) | If you want to enable object lock, by default its disabled | `bool` | `false` | no |
| <a name="input_owner"></a> [owner](#input\_owner) | Owner of the s3 bucket being provisioned | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Provide region name | `string` | n/a | yes |
| <a name="input_replication_region"></a> [replication\_region](#input\_replication\_region) | Provide region name where we need to replicate | `string` | `"ap-southeast-1"` | no |
| <a name="input_restrict_public_buckets"></a> [restrict\_public\_buckets](#input\_restrict\_public\_buckets) | Whether Amazon S3 should restrict public bucket policies for this bucket. | `bool` | `true` | no |
| <a name="input_route_table_id"></a> [route\_table\_id](#input\_route\_table\_id) | Provide Private route\_table\_id | `string` | `""` | no |
| <a name="input_versioning"></a> [versioning](#input\_versioning) | Provide input to Enable versioning True / false | `bool` | `true` | no |
| <a name="input_vpc_endpoint"></a> [vpc\_endpoint](#input\_vpc\_endpoint) | Set to true if want to create a S3 VPC endpoint | `bool` | `false` | no |
| <a name="input_vpc_endpoint_name"></a> [vpc\_endpoint\_name](#input\_vpc\_endpoint\_name) | Name of the vpc\_endpoint | `string` | `""` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Provide vpc\_id | `string` | `""` | no |
| <a name="input_website"></a> [website](#input\_website) | Map containing static web-site hosting or redirect configuration. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_s3_bucket_arn"></a> [s3\_bucket\_arn](#output\_s3\_bucket\_arn) | The ARN of the bucket. Will be of format arn:aws:s3:::bucketname |
| <a name="output_s3_bucket_bucket_domain_name"></a> [s3\_bucket\_bucket\_domain\_name](#output\_s3\_bucket\_bucket\_domain\_name) | The bucket domain name. Will be of format bucketname.s3.amazonaws.com |
| <a name="output_s3_bucket_id"></a> [s3\_bucket\_id](#output\_s3\_bucket\_id) | The name of the bucket |
| <a name="output_s3_replica_bucket_arn"></a> [s3\_replica\_bucket\_arn](#output\_s3\_replica\_bucket\_arn) | The ARN of the bucket. Will be of format arn:aws:s3:::bucketname |
| <a name="output_s3_replica_bucket_bucket_domain_name"></a> [s3\_replica\_bucket\_bucket\_domain\_name](#output\_s3\_replica\_bucket\_bucket\_domain\_name) | The bucket domain name. Will be of format bucketname.s3.amazonaws.com |
| <a name="output_s3_replica_bucket_id"></a> [s3\_replica\_bucket\_id](#output\_s3\_replica\_bucket\_id) | The name of the bucket |
| <a name="output_vpc_endpoint"></a> [vpc\_endpoint](#output\_vpc\_endpoint) | n/a |
<!-- END_TF_DOCS -->
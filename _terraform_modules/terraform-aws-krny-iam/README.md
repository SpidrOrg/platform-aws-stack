<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.oidc_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.existing_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.new_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.oidc_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.oidc_attachment_custom](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume_role_with_oidc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [template_file.policy_document](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.role_document](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assume_role_arn"></a> [assume\_role\_arn](#input\_assume\_role\_arn) | ARN of the IAM role to be assumed while creating the resources | `string` | `""` | no |
| <a name="input_assume_role_policy_path"></a> [assume\_role\_policy\_path](#input\_assume\_role\_policy\_path) | Path of the assume role policy to be applied to the role | `string` | `""` | no |
| <a name="input_assume_role_policy_vars"></a> [assume\_role\_policy\_vars](#input\_assume\_role\_policy\_vars) | Assume role policy variables to substitue in policy document(if any) | `map(string)` | `{}` | no |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | The AWS account ID where the OIDC provider lives, leave empty to use the account for the AWS provider | `string` | `""` | no |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | Common tags to associate with resources | `map(string)` | `{}` | no |
| <a name="input_create_oidc_role"></a> [create\_oidc\_role](#input\_create\_oidc\_role) | Whether to create OIDC role | `bool` | `false` | no |
| <a name="input_create_policy"></a> [create\_policy](#input\_create\_policy) | Whether to create IAM policy or not | `bool` | `false` | no |
| <a name="input_create_role"></a> [create\_role](#input\_create\_role) | Whether to create an IAM role | `bool` | `false` | no |
| <a name="input_force_detach_policies"></a> [force\_detach\_policies](#input\_force\_detach\_policies) | Whether to force detaching any policies the role has before destroying it | `bool` | `true` | no |
| <a name="input_max_session_duration"></a> [max\_session\_duration](#input\_max\_session\_duration) | Maximum session duration (in seconds) that you want to set for the role | `number` | `3600` | no |
| <a name="input_oidc_force_detach_policies"></a> [oidc\_force\_detach\_policies](#input\_oidc\_force\_detach\_policies) | Whether to force detaching any policies the OIDC role has before destroying it | `bool` | `true` | no |
| <a name="input_oidc_fully_qualified_subjects"></a> [oidc\_fully\_qualified\_subjects](#input\_oidc\_fully\_qualified\_subjects) | The fully qualified OIDC subjects to be added to the role policy | `set(string)` | `[]` | no |
| <a name="input_oidc_max_session_duration"></a> [oidc\_max\_session\_duration](#input\_oidc\_max\_session\_duration) | Maximum session duration (in seconds) that you want to set for the OIDC role | `number` | `3600` | no |
| <a name="input_oidc_role_description"></a> [oidc\_role\_description](#input\_oidc\_role\_description) | Description of the OIDC role | `string` | `""` | no |
| <a name="input_oidc_role_name"></a> [oidc\_role\_name](#input\_oidc\_role\_name) | Name of the OIDC role | `string` | `""` | no |
| <a name="input_oidc_role_policy_arns"></a> [oidc\_role\_policy\_arns](#input\_oidc\_role\_policy\_arns) | List of ARNs of IAM policies to attach to OIDC role | `list(string)` | `[]` | no |
| <a name="input_oidc_subjects_with_wildcards"></a> [oidc\_subjects\_with\_wildcards](#input\_oidc\_subjects\_with\_wildcards) | The OIDC subject using wildcards to be added to the role policy | `set(string)` | `[]` | no |
| <a name="input_policy_description"></a> [policy\_description](#input\_policy\_description) | Description of the policy | `string` | `""` | no |
| <a name="input_policy_name"></a> [policy\_name](#input\_policy\_name) | Name of the policy | `string` | `""` | no |
| <a name="input_policy_path"></a> [policy\_path](#input\_policy\_path) | The path of the policy document to be used to create policy | `string` | `""` | no |
| <a name="input_policy_vars"></a> [policy\_vars](#input\_policy\_vars) | Policy variables to substitue in policy document(if any) | `map(string)` | `{}` | no |
| <a name="input_provider_urls"></a> [provider\_urls](#input\_provider\_urls) | List of URLs of the OIDC providers | `list(string)` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region in which resources are to be created | `string` | `"ap-south-1"` | no |
| <a name="input_role_description"></a> [role\_description](#input\_role\_description) | Description of the role | `string` | `""` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | Name of the role to be created | `string` | `""` | no |
| <a name="input_role_permissions_boundary_arn"></a> [role\_permissions\_boundary\_arn](#input\_role\_permissions\_boundary\_arn) | ARN of the policy that is used to set the permissions boundary for the role | `string` | `""` | no |
| <a name="input_role_policy_arns"></a> [role\_policy\_arns](#input\_role\_policy\_arns) | List of ARNs of existing policies to associate with the role | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_policy_arn"></a> [iam\_policy\_arn](#output\_iam\_policy\_arn) | The ARN assigned by AWS to this policy. |
| <a name="output_iam_policy_name"></a> [iam\_policy\_name](#output\_iam\_policy\_name) | The name of the policy. |
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | ARN of IAM role |
| <a name="output_iam_role_name"></a> [iam\_role\_name](#output\_iam\_role\_name) | Name of IAM role |
| <a name="output_oidc_role_arn"></a> [oidc\_role\_arn](#output\_oidc\_role\_arn) | ARN of IAM role |
| <a name="output_oidc_role_name"></a> [oidc\_role\_name](#output\_oidc\_role\_name) | Name of IAM role |
<!-- END_TF_DOCS -->
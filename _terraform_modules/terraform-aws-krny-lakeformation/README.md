# terraform-aws-xebia-lake-formation
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lake-formation"></a> [lake-formation](#module\_lake-formation) | ./modules/terraform-aws-lakeformation-0.1.0 | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_arn_list"></a> [admin\_arn\_list](#input\_admin\_arn\_list) | Set of ARNs of AWS Lake Formation principals (IAM users or roles). | `list(string)` | `[]` | no |
| <a name="input_assume_role_arn"></a> [assume\_role\_arn](#input\_assume\_role\_arn) | assume role in which account to create | `string` | `""` | no |
| <a name="input_catalog_id"></a> [catalog\_id](#input\_catalog\_id) | Identifier for the Data Catalog. If not provided, the account ID will be used. | `string` | `null` | no |
| <a name="input_database_default_permissions"></a> [database\_default\_permissions](#input\_database\_default\_permissions) | Up to three configuration blocks of principal permissions for default create database permissions. | `list(any)` | `[]` | no |
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | Add extra tags to your resource | `map(string)` | `{}` | no |
| <a name="input_lf_tags"></a> [lf\_tags](#input\_lf\_tags) | A map of key-value pairs to be used as Lake Formation tags. | `map(list(string))` | `{}` | no |
| <a name="input_region"></a> [region](#input\_region) | provider region, where resources will be created | `string` | `"ap-south-1"` | no |
| <a name="input_resources"></a> [resources](#input\_resources) | A map of Lake Formation resources to create, with related attributes. | `map(any)` | `{}` | no |
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn) | Role that has read/write access to the Lake Formation resource. If not provided, the Lake Formation service-linked role must exist and is used. | `string` | `null` | no |
| <a name="input_s3_bucket_arn"></a> [s3\_bucket\_arn](#input\_s3\_bucket\_arn) | Amazon Resource Name (ARN) of the Lake Formation resource, an S3 path. | `string` | n/a | yes |
| <a name="input_table_default_permissions"></a> [table\_default\_permissions](#input\_table\_default\_permissions) | Up to three configuration blocks of principal permissions for default create table permissions. | `list(map(any))` | `[]` | no |
| <a name="input_trusted_resource_owners"></a> [trusted\_resource\_owners](#input\_trusted\_resource\_owners) | List of the resource-owning account IDs that the caller's account can use to share their user access details (user ARNs). | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lf_tags"></a> [lf\_tags](#output\_lf\_tags) | List of LF tags created. |
<!-- END_TF_DOCS -->
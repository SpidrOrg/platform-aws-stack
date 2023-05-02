# terraform-aws-xebia-vpc-endpoints
Terraform Module to add VPC Endpoints

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

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_vpc_endpoint.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_security_group_ids"></a> [additional\_security\_group\_ids](#input\_additional\_security\_group\_ids) | Additional security group IDs to associate with the VPC endpoints | `list(string)` | `[]` | no |
| <a name="input_assume_role_arn"></a> [assume\_role\_arn](#input\_assume\_role\_arn) | ARN of the role to be assumed while creating resources | `string` | `""` | no |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | Common tags to be added to all resources | `map(string)` | `{}` | no |
| <a name="input_create_endpoint_sg"></a> [create\_endpoint\_sg](#input\_create\_endpoint\_sg) | Whether to a security group to be associated with interface endpoints | `bool` | `true` | no |
| <a name="input_egress_rules"></a> [egress\_rules](#input\_egress\_rules) | List of egress rules to add to the endpoint security group | `list(map(any))` | `[]` | no |
| <a name="input_endpoints"></a> [endpoints](#input\_endpoints) | A list of interface and/or gateway endpoints containing their properties and configurations | `list(any)` | `[]` | no |
| <a name="input_ingress_rules"></a> [ingress\_rules](#input\_ingress\_rules) | List of ingress rules to add to the endpoint security group | `list(map(any))` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | This is the region in which resources will be created | `string` | `"ap-south-1"` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Subnets IDs to associate with the VPC endpoints | `list(string)` | n/a | yes |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | Define maximum timeout for creating, updating, and deleting VPC endpoint resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC in which the endpoint will be used | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_endpoint_sg_id"></a> [endpoint\_sg\_id](#output\_endpoint\_sg\_id) | ID of the endpoint security group |
| <a name="output_endpoints"></a> [endpoints](#output\_endpoints) | Array containing the full resource object and attributes for all endpoints created |
<!-- END_TF_DOCS -->
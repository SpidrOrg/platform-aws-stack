variable "region" {
  type        = string
  default     = "ap-south-1"
  description = "AWS region where resources will be created."
}
variable "assume_role_arn" {
  type        = string
  default     = ""
  description = "The role to be assumed while creating resources."
}
variable "common_tags" {
  type        = map(string)
  default     = {}
  description = "Common tags to add to resources."
}

################################################################################
# VPC
################################################################################

variable "name" {
  type        = string
  description = "Name of the VPC."
}
variable "cidr" {
  type        = string
  description = "The CIDR block for the VPC."
}
variable "secondary_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "list of additional ipv4 cidr blocks to associate with vpc"
}
variable "enable_dns_hostnames" {
  type        = bool
  default     = true
  description = "Should be true to enable DNS hostnames in the VPC."
}
variable "enable_dns_support" {
  type        = bool
  default     = true
  description = "Determines whether the VPC supports DNS resolution through the Amazon provided DNS server."
}
variable "enable_ipv6" {
  type        = bool
  default     = false
  description = "Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC"
}
variable "tags" {
  type        = map(string)
  default     = {}
  description = "additional tags to associate with vpc"
}

################################################################################
# PUBLIC SUBNETS
################################################################################

variable "public_subnets" {
  type        = list(any)
  default     = []
  description = "list of private subnets to create inside the VPC"
}
variable "create_igw" {
  type        = bool
  default     = false
  description = "whether internet gateway and related routes needs to be created for public subnets"
}

################################################################################
# PUBLIC NETWORK ACLs
################################################################################

variable "enable_public_dedicated_network_acl" {
  type        = bool
  default     = false
  description = "whether to use dedicated network ACL (non-default) and custom rules for public subnets"
}
variable "public_inbound_acl_rules" {
  type = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
  description = "public subnets inbound network ACL rules"
}
variable "public_outbound_acl_rules" {
  type = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
  description = "public subnets outbound network ACL rules"
}

################################################################################
# PRIVATE SUBNETS
################################################################################

variable "private_subnets" {
  type        = list(any)
  default     = []
  description = "list of private subnets to create inside the VPC"
}
variable "enable_nat_gateway" {
  type        = bool
  default     = false
  description = "whether to create NAT gateway(s)"
}
variable "single_nat_gateway" {
  type        = bool
  default     = false
  description = "whether to create a single shared NAT gateway for all private subnets"
}
variable "one_nat_gateway_per_az" {
  type        = bool
  default     = false
  description = "Should be true if you want only one NAT Gateway per availability zone. Requires `var.azs` to be set, and the number of `public_subnets` created to be greater than or equal to the number of availability zones specified in `var.azs`"
}
variable "reuse_nat_ips" {
  type        = bool
  default     = false
  description = "whether to use existing EIP(s) for NAT Gateway(s) being created instead of creating new EIP(s)"
}
variable "external_nat_ip_ids" {
  type        = list(string)
  default     = []
  description = "list of EIP ID(s) to be assigned to the NAT Gateway(s)"
}

################################################################################
# PRIVATE NETWORK ACLs
################################################################################

variable "enable_private_dedicated_network_acl" {
  type        = bool
  default     = false
  description = "whether to use dedicated network ACL (non-default) and custom rules for private subnets"
}
variable "private_inbound_acl_rules" {
  type = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
  description = "private subnets inbound network ACL rules"
}
variable "private_outbound_acl_rules" {
  type = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
  description = "private subnets outbound network ACL rules"
}

################################################################################
# DATABASE SUBNETS
################################################################################

variable "database_subnets" {
  type        = list(any)
  default     = []
  description = "list of database subnets to create inside the VPC"
}
variable "create_database_subnet_group" {
  type        = bool
  default     = false
  description = "whether to create database subnet group"
}
variable "database_subnet_group_name" {
  type        = string
  default     = ""
  description = "name of database subnet group"
}

################################################################################
# DATABASE NETWORK ACLs
################################################################################

variable "enable_database_dedicated_network_acl" {
  type        = bool
  default     = false
  description = "whether to use dedicated network ACL (non-default) and custom rules for database subnets"
}
variable "database_inbound_acl_rules" {
  type = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
  description = "database subnets inbound network ACL rules"
}
variable "database_outbound_acl_rules" {
  type = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
  description = "database subnets outbound network ACL rules"
}

################################################################################
# VPC DEFAULT SECURITY GROUP
################################################################################

variable "manage_default_security_group" {
  type        = bool
  default     = false
  description = "whether to manage default security group"
}
variable "default_security_group_name" {
  type        = string
  default     = ""
  description = "name of the default security group"
}
variable "default_security_group_ingress" {
  type        = list(map(string))
  default     = []
  description = "ingress rules for default security group of the vpc"
}
variable "default_security_group_egress" {
  type        = list(map(string))
  default     = []
  description = "egress rules for default security group of the vpc"
}

################################################################################
# DEFAULT ROUTE TABLE
################################################################################

variable "manage_default_route_table" {
  type        = bool
  default     = false
  description = "should be true to manage default route table"
}
variable "default_route_table_propagating_vgws" {
  type        = list(string)
  default     = []
  description = "list of virtual gateways for propagation"
}
variable "default_route_table_routes" {
  type        = list(map(string))
  default     = []
  description = "list of rules to add to default route table"
}

################################################################################
# DEFAULT NETWORK ACLs
################################################################################

variable "manage_default_network_acl" {
  type        = bool
  default     = false
  description = "whether to adopt and manage default network ACL"
}
variable "default_network_acl_name" {
  type        = string
  default     = ""
  description = "name to associate with default network ACL"
}
variable "default_network_acl_ingress" {
  type = list(map(string))
  default = [
    {
      rule_no    = 100
      action     = "allow"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
      cidr_block = "0.0.0.0/0"
    },
    {
      rule_no         = 101
      action          = "allow"
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      ipv6_cidr_block = "::/0"
    },
  ]
  description = "list of ingress rules to set on the default network ACL"
}
variable "default_network_acl_egress" {
  type = list(map(string))
  default = [
    {
      rule_no    = 100
      action     = "allow"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
      cidr_block = "0.0.0.0/0"
    },
    {
      rule_no         = 101
      action          = "allow"
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      ipv6_cidr_block = "::/0"
    },
  ]
  description = "list of egress rules to set on the default network ACL"
}

################################################################################
# CUSTOMER GATEWAYS
################################################################################

variable "customer_gateways" {
  type        = map(map(any))
  default     = {}
  description = "Maps of Customer Gateway's attributes (BGP ASN and Gateway's Internet-routable external IP address)"
}

################################################################################
# FLOW LOGS
################################################################################

variable "enable_flow_log" {
  type        = bool
  default     = true
  description = "whether or not to enable VPC flow logs"
}
variable "flow_log_destination_type" {
  type        = string
  default     = "cloud-watch-logs"
  description = "Type of flow log destination. Can be s3 or cloud-watch-logs"
  validation {
    error_message = "Valid values are s3 and cloud-watch-logs."
    condition     = contains(["s3", "cloud-watch-logs"], var.flow_log_destination_type)
  }
}
variable "flow_log_destination_arn" {
  type        = string
  default     = ""
  description = "the ARN of the cloudwatch log group or s3 bucket where VPC flow logs will be pushed"
}
variable "flow_log_traffic_type" {
  type        = string
  default     = "ALL"
  description = "the type of traffic to capture, valid values are ACCEPT, REJECT, ALL"
  validation {
    error_message = "Valid values are ACCEPT, REJECT, ALL."
    condition     = contains(["ACCEPT", "REJECT", "ALL"], var.flow_log_traffic_type)
  }
}
variable "flow_log_max_aggregation_interval" {
  type        = number
  default     = 600
  description = "the max interval of time during which a particular flow is captured and aggregated into a flow record"
  validation {
    error_message = "Valid values are 60, 600."
    condition     = contains([60, 600], var.flow_log_max_aggregation_interval)
  }
}

################################################################################
# FLOW LOG CLOUDWATCH
################################################################################

variable "create_flow_log_cloudwatch_log_group" {
  type        = bool
  default     = true
  description = "whether to create cloudwatch log group for VPC flow logs"
}
variable "flow_log_cloudwatch_log_group_name_prefix" {
  type        = string
  default     = "/aws/vpc-flow-log/"
  description = "name prefix of cloudwatch log group for VPC flow logs"
}
variable "create_flow_log_cloudwatch_iam_role" {
  type        = bool
  default     = true
  description = "whether to create an IAM role for VPC flow logs"
}
variable "flow_log_cloudwatch_iam_role_arn" {
  type        = string
  default     = ""
  description = "ARN of existing IAM role for VPC flow log cloudwatch log group"
}
variable "flow_log_cloudwatch_log_group_retention_in_days" {
  type        = number
  default     = null
  description = "no of days log events should be retained"
}
variable "flow_log_cloudwatch_log_group_kms_key_id" {
  type        = string
  default     = null
  description = "ARN of the KMS key to use when encyrpting log data for VPC flow logs"
}
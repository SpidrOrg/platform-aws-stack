region      = "ap-south-1"
common_tags = { "Environmet" : "Dev" }
name        = "labtest"
cidr        = "10.0.0.0/22"
public_subnets = [{
  "name"              = "labtest-public-1a",
  "cidr_block"        = "10.0.0.0/25",
  "availability_zone" = "ap-south-1a",
  "tags" = {
    "Type" = "Public"
  }
  },
  {
    "name"              = "labtest-public-1b",
    "cidr_block"        = "10.0.0.128/25",
    "availability_zone" = "ap-south-1b",
    "tags" = {
      "Type" = "Public"
    }
  }
]
private_subnets = [
  {
    "name"              = "labtest-private-workload-1a",
    "cidr_block"        = "10.0.1.0/25",
    "availability_zone" = "ap-south-1a",
    "tags" = {
      "Type" = "Private"
    }
  },
  {
    "name"              = "labtest-private-workload-1b",
    "cidr_block"        = "10.0.1.128/25",
    "availability_zone" = "ap-south-1b"
    "tags" = {
      "Type" = "Private"
    }
  }
]
database_subnets = [
  # {
  #   "name"              = "labtest-db-1a",
  #   "cidr_block"        = "10.0.2.0/25",
  #   "availability_zone" = "ap-south-1a",
  # },
  # {
  #   "name"              = "labtest-db-1b",
  #   "cidr_block"        = "10.0.2.128/25",
  #   "availability_zone" = "ap-south-1b"
  # }
]
create_igw             = true
enable_nat_gateway     = true
single_nat_gateway     = true
one_nat_gateway_per_az = false

manage_default_security_group  = false
default_security_group_ingress = []
default_security_group_egress  = []

# VPC FLOW LOGS
enable_flow_log                                 = true
flow_log_cloudwatch_log_group_retention_in_days = 60
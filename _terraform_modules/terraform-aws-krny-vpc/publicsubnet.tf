################################################################################
# Public subnet
################################################################################

resource "aws_subnet" "public" {
  count                           = length(var.public_subnets)
  vpc_id                          = local.vpc_id
  cidr_block                      = var.public_subnets[count.index].cidr_block
  availability_zone               = var.public_subnets[count.index].availability_zone
  map_public_ip_on_launch         = try(var.public_subnets[count.index].map_public_ip_on_launch, false)
  assign_ipv6_address_on_creation = try(var.public_subnets[count.index].assign_ipv6_address_on_creation, false)
  ipv6_cidr_block                 = try(var.public_subnets[count.index].ipv6_cidr_block, null)
  tags = merge(
    {
      "Name" = var.public_subnets[count.index].name
    },
    try(var.public_subnets[count.index].tags, {})
  )
}

################################################################################
# Public Network ACLs
################################################################################

resource "aws_network_acl" "public" {
  count      = var.enable_public_dedicated_network_acl && length(var.public_subnets) > 0 ? 1 : 0
  vpc_id     = element(concat(aws_vpc.vpc.*.id, [""]), 0)
  subnet_ids = aws_subnet.public.*.id
  tags = {
    "Name" = format("%s-public", var.name)
  }
}

resource "aws_network_acl_rule" "public_inbound" {
  count           = var.enable_public_dedicated_network_acl && length(var.public_subnets) > 0 ? length(var.public_inbound_acl_rules) : 0
  network_acl_id  = aws_network_acl.public[0].id
  egress          = false
  rule_number     = var.public_inbound_acl_rules[count.index]["rule_number"]
  rule_action     = var.public_inbound_acl_rules[count.index]["rule_action"]
  from_port       = lookup(var.public_inbound_acl_rules[count.index], "from_port", null)
  to_port         = lookup(var.public_inbound_acl_rules[count.index], "to_port", null)
  icmp_code       = lookup(var.public_inbound_acl_rules[count.index], "icmp_code", null)
  icmp_type       = lookup(var.public_inbound_acl_rules[count.index], "icmp_type", null)
  protocol        = var.public_inbound_acl_rules[count.index]["protocol"]
  cidr_block      = lookup(var.public_inbound_acl_rules[count.index], "cidr_block", null)
  ipv6_cidr_block = lookup(var.public_inbound_acl_rules[count.index], "ipv6_cidr_block", null)
}

resource "aws_network_acl_rule" "public_outbound" {
  count           = var.enable_public_dedicated_network_acl && length(var.public_subnets) > 0 ? length(var.public_outbound_acl_rules) : 0
  network_acl_id  = aws_network_acl.public[0].id
  egress          = true
  rule_number     = var.public_outbound_acl_rules[count.index]["rule_number"]
  rule_action     = var.public_outbound_acl_rules[count.index]["rule_action"]
  from_port       = lookup(var.public_outbound_acl_rules[count.index], "from_port", null)
  to_port         = lookup(var.public_outbound_acl_rules[count.index], "to_port", null)
  icmp_code       = lookup(var.public_outbound_acl_rules[count.index], "icmp_code", null)
  icmp_type       = lookup(var.public_outbound_acl_rules[count.index], "icmp_type", null)
  protocol        = var.public_outbound_acl_rules[count.index]["protocol"]
  cidr_block      = lookup(var.public_outbound_acl_rules[count.index], "cidr_block", null)
  ipv6_cidr_block = lookup(var.public_outbound_acl_rules[count.index], "ipv6_cidr_block", null)
}

################################################################################
# Internet Gateway
################################################################################

resource "aws_internet_gateway" "igw" {
  count  = var.create_igw && length(var.public_subnets) > 0 ? 1 : 0
  vpc_id = local.vpc_id
  tags = {
    "Name" = format("%s", var.name)
  }
}

################################################################################
# Publiс routes
################################################################################

resource "aws_route_table" "public" {
  count  = length(var.public_subnets) > 0 ? 1 : 0
  vpc_id = local.vpc_id
  tags = {
    "Name" = format("%s-public", var.name)
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets) > 0 ? length(var.public_subnets) : 0
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public[0].id
}

resource "aws_route" "public_internet_gateway" {
  count                  = var.create_igw && length(var.public_subnets) > 0 ? 1 : 0
  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw[0].id
  timeouts {
    create = "5m"
  }
}

resource "aws_route" "public_internet_gateway_ipv6" {
  count                       = var.enable_ipv6 && length(var.public_subnets) > 0 ? 1 : 0
  route_table_id              = aws_route_table.public[0].id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.igw[0].id
}
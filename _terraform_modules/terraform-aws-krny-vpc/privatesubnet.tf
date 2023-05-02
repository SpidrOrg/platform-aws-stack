################################################################################
# Private subnet
################################################################################

resource "aws_subnet" "private" {
  count                           = length(var.private_subnets)
  vpc_id                          = local.vpc_id
  cidr_block                      = var.private_subnets[count.index].cidr_block
  availability_zone               = var.private_subnets[count.index].availability_zone
  assign_ipv6_address_on_creation = try(var.private_subnets[count.index].assign_ipv6_address_on_creation, null)
  ipv6_cidr_block                 = try(var.private_subnets[count.index].ipv6_cidr_block, null)
  tags = merge(
    {
      "Name" = var.private_subnets[count.index].name
    },
    try(var.private_subnets[count.index].tags, {})
  )
}

################################################################################
# Private Network ACLs
################################################################################

resource "aws_network_acl" "private" {
  count      = var.enable_private_dedicated_network_acl && length(var.private_subnets) > 0 ? 1 : 0
  vpc_id     = element(concat(aws_vpc.vpc.*.id, [""]), 0)
  subnet_ids = aws_subnet.private.*.id
  tags = {
    "Name" = format("%s-private", var.name)
  }
}

resource "aws_network_acl_rule" "private_inbound" {
  count           = var.enable_private_dedicated_network_acl && length(var.private_subnets) > 0 ? length(var.private_inbound_acl_rules) : 0
  network_acl_id  = aws_network_acl.private[0].id
  egress          = false
  rule_number     = var.private_inbound_acl_rules[count.index]["rule_number"]
  rule_action     = var.private_inbound_acl_rules[count.index]["rule_action"]
  from_port       = lookup(var.private_inbound_acl_rules[count.index], "from_port", null)
  to_port         = lookup(var.private_inbound_acl_rules[count.index], "to_port", null)
  icmp_code       = lookup(var.private_inbound_acl_rules[count.index], "icmp_code", null)
  icmp_type       = lookup(var.private_inbound_acl_rules[count.index], "icmp_type", null)
  protocol        = var.private_inbound_acl_rules[count.index]["protocol"]
  cidr_block      = lookup(var.private_inbound_acl_rules[count.index], "cidr_block", null)
  ipv6_cidr_block = lookup(var.private_inbound_acl_rules[count.index], "ipv6_cidr_block", null)
}

resource "aws_network_acl_rule" "private_outbound" {
  count           = var.enable_private_dedicated_network_acl && length(var.private_subnets) > 0 ? length(var.private_outbound_acl_rules) : 0
  network_acl_id  = aws_network_acl.private[0].id
  egress          = true
  rule_number     = var.private_outbound_acl_rules[count.index]["rule_number"]
  rule_action     = var.private_outbound_acl_rules[count.index]["rule_action"]
  from_port       = lookup(var.private_outbound_acl_rules[count.index], "from_port", null)
  to_port         = lookup(var.private_outbound_acl_rules[count.index], "to_port", null)
  icmp_code       = lookup(var.private_outbound_acl_rules[count.index], "icmp_code", null)
  icmp_type       = lookup(var.private_outbound_acl_rules[count.index], "icmp_type", null)
  protocol        = var.private_outbound_acl_rules[count.index]["protocol"]
  cidr_block      = lookup(var.private_outbound_acl_rules[count.index], "cidr_block", null)
  ipv6_cidr_block = lookup(var.private_outbound_acl_rules[count.index], "ipv6_cidr_block", null)
}

################################################################################
# NAT Gateway
################################################################################

resource "aws_eip" "nat" {
  count = var.enable_nat_gateway && var.reuse_nat_ips == false ? local.nat_gateway_count : 0
  vpc   = true
  tags = {
    "Name" = format(
      "%s-%s",
      var.name,
      element(local.az_list, var.single_nat_gateway ? 0 : count.index),
    )
  }
}

resource "aws_nat_gateway" "nat" {
  count = var.enable_nat_gateway ? local.nat_gateway_count : 0
  allocation_id = element(
    local.nat_gateway_ips,
    var.single_nat_gateway ? 0 : count.index,
  )
  subnet_id = element(
    aws_subnet.public.*.id,
    var.single_nat_gateway ? 0 : count.index,
  )
  tags = {
    "Name" = format(
      "%s-%s",
      var.name,
      element(local.az_list, var.single_nat_gateway ? 0 : count.index),
    )
  }
  depends_on = [aws_internet_gateway.igw]
}

################################################################################
# Private routes
################################################################################

resource "aws_route_table" "private" {
  count  = var.enable_nat_gateway ? local.nat_gateway_count : length(var.private_subnets)
  vpc_id = local.vpc_id
  tags = {
    "Name" = var.enable_nat_gateway && var.single_nat_gateway ? "${var.name}-private" : var.private_subnets[count.index].name
  }
}

resource "aws_route_table_association" "private" {
  count     = var.single_nat_gateway || var.enable_nat_gateway == false ? length(var.private_subnets) : local.nat_gateway_count
  subnet_id = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(
    aws_route_table.private.*.id,
    var.single_nat_gateway ? 0 : count.index,
  )
}

resource "aws_route" "private_nat_gateway" {
  count                  = var.enable_nat_gateway ? local.nat_gateway_count : 0
  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.nat.*.id, count.index)
  timeouts {
    create = "5m"
  }
}
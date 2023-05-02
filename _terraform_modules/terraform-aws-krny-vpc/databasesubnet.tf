################################################################################
# Database subnet
################################################################################

resource "aws_subnet" "database" {
  count                           = length(var.database_subnets)
  vpc_id                          = local.vpc_id
  cidr_block                      = var.database_subnets[count.index].cidr_block
  availability_zone               = var.database_subnets[count.index].availability_zone
  assign_ipv6_address_on_creation = try(var.database_subnets[count.index].assign_ipv6_address_on_creation, false)
  ipv6_cidr_block                 = try(var.database_subnets[count.index].ipv6_cidr_block, null)
  tags = merge(
    {
      "Name" = var.database_subnets[count.index].name
    },
    try(var.database_subnets[count.index].tags, {})
  )
}

resource "aws_db_subnet_group" "database" {
  count       = length(var.database_subnets) > 0 && var.create_database_subnet_group ? 1 : 0
  name        = lower(coalesce(var.database_subnet_group_name, var.name))
  description = "Database subnet group for ${var.name}"
  subnet_ids  = aws_subnet.database.*.id
  tags = {
    "Name" = format("%s", lower(coalesce(var.database_subnet_group_name, var.name)))
  }
}

################################################################################
# Database Network ACLs
################################################################################

resource "aws_network_acl" "database" {
  count      = var.enable_database_dedicated_network_acl && length(var.database_subnets) > 0 ? 1 : 0
  vpc_id     = element(concat(aws_vpc.vpc.*.id, [""]), 0)
  subnet_ids = aws_subnet.database.*.id
  tags = {
    "Name" = format("%s-db", var.name)
  }
}

resource "aws_network_acl_rule" "database_inbound" {
  count           = var.enable_database_dedicated_network_acl && length(var.database_subnets) > 0 ? length(var.database_inbound_acl_rules) : 0
  network_acl_id  = aws_network_acl.database[0].id
  egress          = false
  rule_number     = var.database_inbound_acl_rules[count.index]["rule_number"]
  rule_action     = var.database_inbound_acl_rules[count.index]["rule_action"]
  from_port       = lookup(var.database_inbound_acl_rules[count.index], "from_port", null)
  to_port         = lookup(var.database_inbound_acl_rules[count.index], "to_port", null)
  icmp_code       = lookup(var.database_inbound_acl_rules[count.index], "icmp_code", null)
  icmp_type       = lookup(var.database_inbound_acl_rules[count.index], "icmp_type", null)
  protocol        = var.database_inbound_acl_rules[count.index]["protocol"]
  cidr_block      = lookup(var.database_inbound_acl_rules[count.index], "cidr_block", null)
  ipv6_cidr_block = lookup(var.database_inbound_acl_rules[count.index], "ipv6_cidr_block", null)
}

resource "aws_network_acl_rule" "database_outbound" {
  count           = var.enable_database_dedicated_network_acl && length(var.database_subnets) > 0 ? length(var.database_outbound_acl_rules) : 0
  network_acl_id  = aws_network_acl.database[0].id
  egress          = true
  rule_number     = var.database_outbound_acl_rules[count.index]["rule_number"]
  rule_action     = var.database_outbound_acl_rules[count.index]["rule_action"]
  from_port       = lookup(var.database_outbound_acl_rules[count.index], "from_port", null)
  to_port         = lookup(var.database_outbound_acl_rules[count.index], "to_port", null)
  icmp_code       = lookup(var.database_outbound_acl_rules[count.index], "icmp_code", null)
  icmp_type       = lookup(var.database_outbound_acl_rules[count.index], "icmp_type", null)
  protocol        = var.database_outbound_acl_rules[count.index]["protocol"]
  cidr_block      = lookup(var.database_outbound_acl_rules[count.index], "cidr_block", null)
  ipv6_cidr_block = lookup(var.database_outbound_acl_rules[count.index], "ipv6_cidr_block", null)
}

################################################################################
# Database Route Table
################################################################################

resource "aws_route_table" "database" {
  count  = length(var.database_subnets) > 0 ? 1 : 0
  vpc_id = local.vpc_id
  tags = {
    "Name" = "${var.name}-db"
  }
}

resource "aws_route_table_association" "database" {
  count          = length(var.database_subnets)
  subnet_id      = element(aws_subnet.database.*.id, count.index)
  route_table_id = aws_route_table.database[0].id
}
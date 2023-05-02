locals {
  az_list           = distinct([for subnet in var.private_subnets : subnet.availability_zone])
  nat_gateway_count = var.enable_nat_gateway && var.single_nat_gateway ? 1 : length(local.az_list)
  # Use `local.vpc_id` to give a hint to Terraform that subnets should be deleted before secondary CIDR blocks can be free!
  vpc_id = element(
    concat(
      aws_vpc_ipv4_cidr_block_association.ipv4_association.*.vpc_id,
      [aws_vpc.vpc.id],
      [""],
    ),
    0,
  )
  # The logical expression would be
  #    nat_gateway_ips = var.reuse_nat_ips ? var.external_nat_ip_ids : aws_eip.nat.*.id
  # but then when count of aws_eip.nat.*.id is zero, this would throw a resource not found error on aws_eip.nat.*.id.
  nat_gateway_ips = split(
    ",",
    var.reuse_nat_ips ? join(",", var.external_nat_ip_ids) : join(",", aws_eip.nat.*.id),
  )
}
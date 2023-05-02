provider "aws" {
  region = var.region
  default_tags {
    tags = var.common_tags
  }
  assume_role {
    role_arn = var.assume_role_arn
  }
}

################################################################################
# ENDPOINTS
################################################################################

resource "aws_vpc_endpoint" "this" {
  for_each            = { for k, v in var.endpoints : k => v }
  vpc_id              = var.vpc_id
  service_name        = try(each.value.service_name, null)
  tags               = try(each.value.tags, null)
  vpc_endpoint_type  = try(each.value.endpoint_type, "Gateway")
  auto_accept        = try(each.value.auto_accept, null)
  }


resource "aws_vpc_endpoint_route_table_association" "this" {
  for_each     = { for k, v in var.endpoints : k => v  }
  route_table_id = var.route_table_id
  vpc_endpoint_id = aws_vpc_endpoint.this[each.key].id
}

provider "aws" {
  region = var.region
  default_tags {
    tags = var.common_tags
  }
  # assume_role {
  #   role_arn = var.assume_role_arn
  # }
}

locals {
  api_gateway_name = var.api_gateway_name == "" ? "${var.project}-apigateway-${var.env}" : var.api_gateway_name
}

data "template_file" "api_policy_json" {
  template = file("${path.module}/templates/policy.json")
  vars = {
    api_allowlist_ips = jsonencode(var.api_allowlist_ips)
  }
}

resource "aws_api_gateway_rest_api" "api" {
  name        = local.api_gateway_name
  description = "${var.project}-${var.env} rest api"
  #body                     = var.rendered_api_swagger_config
  policy                   = var.use_api_allowed_ips ? data.template_file.api_policy_json.rendered : ""
  minimum_compression_size = var.minimum_compression_size

  body = jsonencode({
    openapi = "3.0.1"
    info = {
      title   = "test"
      version = "1.0"
    }
    paths = {
      "/path" = {
        get = {
          x-amazon-apigateway-integration = {
            httpMethod           = "GET"
            payloadFormatVersion = "1.0"
            type                 = "HTTP_PROXY"
            uri                  = "https://ip-ranges.amazonaws.com/ip-ranges.json"
          }
        }
      }
    }
  })

  endpoint_configuration {
    types = [var.endpoint_type]
  }
  tags = merge(
    var.common_tags,
    {
      "Name" = var.env
    },
  )
}

resource "aws_api_gateway_deployment" "deploy_api" {
  depends_on = [aws_api_gateway_rest_api.api]

  rest_api_id = aws_api_gateway_rest_api.api.id

  variables = {
    deployed_at = timestamp()
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "api_stage" {
  stage_name    = var.env
  rest_api_id   = aws_api_gateway_rest_api.api.id
  deployment_id = aws_api_gateway_deployment.deploy_api.id

  variables = {
    deployed_at = timestamp()
  }

  tags = merge(
    var.common_tags,
    {
      "Name" = var.env
    },
  )

  lifecycle {
    create_before_destroy = true
  }
}

# resource "aws_api_gateway_base_path_mapping" "api_path_mapping" {
#   api_id      = aws_api_gateway_rest_api.api.id
#   stage_name  = aws_api_gateway_stage.api_stage.stage_name
#   domain_name = var.apigateway_domain_name
#   base_path   = var.apigateway_domain_application_mapping_path
# }

resource "aws_api_gateway_method_settings" "api_settings" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = aws_api_gateway_stage.api_stage.stage_name
  method_path = "*/*"
  settings {
    #logging_level          = var.logging_level
    data_trace_enabled     = true
    metrics_enabled        = true
    throttling_burst_limit = var.api_throttling_burst_limit
    throttling_rate_limit  = var.api_throttling_rate_limit
  }
}


# Overview

This module will do the following:
- Create CloudFront for S3 website hosting
- Also includes certificate ARN and aliases

## Usage

```terraform
provider "aws" {
  region  = var.region
  default_tags {
   tags = {
      Project = var.project
      Environment = var.environment
      CreatedBy = "Terraform"
      CostCategory = var.cost_category
      Job = var.job
   }
 }
}

terraform {
  backend "s3" {}
}

data "aws_caller_identity" "current" {}

locals {
  cloudfront_origin_access_identity = "access-identity-${var.project}-${var.environment}.s3.amazonaws.com"
  fqdn = "S3-${var.project}-${var.environment}"
  cname = "${var.project}-${var.environment}.levi-site.com"
  s3bucket_domain_name = "${var.project}-${var.environment}.s3.amazonaws.com"
  account_id = data.aws_caller_identity.current.account_id
  cert_arn = "arn:aws:acm:${var.cert_region}:${local.account_id}:certificate/${var.cert_no}"
}

module "cloudfront" {
  source = "git@github.levi-site.com:LSCO/terraform-CloudFront.git?ref=RELEASE_VERSION"

  aliases = ["${local.cname}"]

  comment             = "My awesome CloudFront"
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  wait_for_deployment = false

  create_origin_access_identity = true
  origin_access_identities = {
    "${local.fqdn}" = local.fqdn
  }

  logging_config = {
    bucket = "logs-my-cdn.s3.amazonaws.com"
  }

  origin = {
    something = {
      domain_name = "something.example.com"
      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "match-viewer"
        origin_ssl_protocols   = ["TLSv1"]
      }
    }

    s3_one = {
      domain_name = local.s3bucket_domain_name
      s3_origin_config = {
        origin_access_identity = local.fqdn
      }
    }
  }

  default_cache_behavior = {
    target_origin_id       = "something"
    viewer_protocol_policy = "allow-all"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    query_string    = true
  }

  ordered_cache_behavior = [
    {
      path_pattern           = "/static/*"
      target_origin_id       = "s3_one"
      viewer_protocol_policy = "redirect-to-https"

      allowed_methods = ["GET", "HEAD", "OPTIONS"]
      cached_methods  = ["GET", "HEAD"]
      compress        = true
      query_string    = true
    }
  ]

  viewer_certificate = {
    acm_certificate_arn = local.cert_arn
    ssl_support_method  = "sni-only"
  }
}
```

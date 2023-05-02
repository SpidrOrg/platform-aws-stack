
#--------s3-metric-------------
/*
resource "aws_s3_bucket_metric" "metrics" {
  bucket = var.bucket_name

  for_each = { for metric in var.metrics : metric.name => metric }

  name = each.value.name

  filter {
    prefix = each.value.prefix ## user input

    tags = each.value.tags ## user input
  }
}*/

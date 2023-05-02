#---------------------------------------------------
# AWS Sagemaker project
#---------------------------------------------------
resource "aws_sagemaker_project" "sagemaker_project" {
  count = var.enable_sagemaker_project ? 1 : 0

  project_name = var.sagemaker_project_name != "" ? var.sagemaker_project_name : "${lower(var.name)}-project-${lower(var.environment)}"

  project_description = var.sagemaker_project_project_description

  dynamic "service_catalog_provisioning_details" {
    iterator = service_catalog_provisioning_details
    for_each = var.sagemaker_project_service_catalog_provisioning_details

    content {
      product_id = lookup(service_catalog_provisioning_details.value, "product_id", null)
    }
  }

  tags = merge(
    {
      Name = var.sagemaker_project_name != "" ? var.sagemaker_project_name : "${lower(var.name)}-project-${lower(var.environment)}"
    },
    var.tags
  )

  lifecycle {
    create_before_destroy = true
    ignore_changes        = []
  }

  depends_on = []
}
resource "aws_s3_object" "data_folders" {
  for_each = var.data_folders_list
  bucket   = var.bucket_name
  key      = "${each.value}/"
}
output "s3_bucket_id" {
  description = "The name of the bucket"
  value       = module.s3_bucket.s3_bucket_id
}

output "s3_bucket_arn" {
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname"
  value       = module.s3_bucket.s3_bucket_arn
}

output "s3_bucket_bucket_domain_name" {
  description = "The bucket domain name. Will be of format bucketname.s3.amazonaws.com"
  value       = module.s3_bucket.s3_bucket_bucket_domain_name
}

output "s3_replica_bucket_id" {
  description = "The name of the bucket"
  value       = var.enable_replication == true ? module.replica_bucket[0].s3_bucket_id : null
}

output "s3_replica_bucket_arn" {
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname"
  value       = var.enable_replication == true ? module.replica_bucket[0].s3_bucket_arn : null
}

output "s3_replica_bucket_bucket_domain_name" {
  description = "The bucket domain name. Will be of format bucketname.s3.amazonaws.com"
  value       = var.enable_replication == true ? module.replica_bucket[0].s3_bucket_bucket_domain_name : null
}

output "vpc_endpoint" {
  value = element(concat(aws_vpc_endpoint.s3.*.arn, [""]), 0)
}
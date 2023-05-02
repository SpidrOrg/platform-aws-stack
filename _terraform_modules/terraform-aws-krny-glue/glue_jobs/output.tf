# # output "job_name" {
# #   value = aws_glue_job.main[count.index]
# # }var.jobs.*.name, count.indexaws_route_table.private[*].id


output "glue_job_name" {
  value = aws_glue_job.main[*].name
}
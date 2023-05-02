variable "bucket_name" {
  description = "The name to use for the bucket"
  type        = string
}

variable "data_folders_list" {
  description = "The list of data folders names"
  type        = set(string)
}
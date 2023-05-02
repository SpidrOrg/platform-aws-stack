variable "database_name" {
  type        = string
  description = "The name of the database to create the crawlers in"
}

variable "crawler1" {
  type        = object({
    name                   = string
    description            = string
    role_arn               = string
    catalog_target_tables  = list(string)
  })
  description = "Settings for the first Glue Crawler"
}

variable "crawler2" {
  type        = object({
    name                   = string
    description            = string
    role_arn               = string
    catalog_target_tables  = list(string)
  })
  description = "Settings for the second Glue Crawler"
}

variable "classifier1" {
  type = list(string)
  default = []
}

variable "classifier2" {
  type = list(string)
  default = []
}
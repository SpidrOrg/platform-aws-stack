variable "classifier_name_1" {
  description = "The name for the first AWS Glue classifier"
  type        = string
}

variable "allow_single_column_1" {
  description = "Whether the first classifier allows for a single column"
  type        = bool
  default     = false
}

variable "contains_header_1" {
  description = "Whether the first classifier contains a header"
  type        = string
  default     = "PRESENT"
}

variable "delimiter_1" {
  description = "The delimiter used in the first classifier"
  type        = string
  default     = ","
}

variable "disable_value_trimming_1" {
  description = "Whether the first classifier disables value trimming"
  type        = bool
  default     = true
}

variable "header_1" {
  description = "The header of the first classifier"
  type        = list(string)
  default     = []
}

variable "quote_symbol_1" {
  description = "The quote symbol used in the first classifier"
  type        = string
  default     = "\""
}

variable "classifier_name_2" {
  description = "The name for the second AWS Glue classifier"
  type        = string
}

variable "allow_single_column_2" {
  description = "Whether the second classifier allows for a single column"
  type        = bool
  default     = false
}

variable "contains_header_2" {
  description = "Whether the second classifier contains a header"
  type        = string
  default     = "PRESENT"
}

variable "delimiter_2" {
  description = "The delimiter used in the second classifier"
  type        = string
  default     = ","
}

variable "disable_value_trimming_2" {
  description = "Whether the second classifier disables value trimming"
  type        = bool
  default     = true
}

variable "header_2" {
  description = "The header of the second classifier"
  type        = list(string)
  default     = []
}

variable "quote_symbol_2" {
  description = "The quote symbol used in the second classifier"
  type        = string
  default     = "\""
}

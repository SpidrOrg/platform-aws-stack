
variable "workflow" {
  description = "Workflow"
  type = object({
    name        = string
    description = string
  })
}

variable "event_trigger" {
  description = "Event Trigger"
  type = object({
    name        = string
    description = string
  })
}

variable "crawler_trigger" {
  description = "Crawler Trigger"
  type = object({
    name        = string
    description = string
  })
}
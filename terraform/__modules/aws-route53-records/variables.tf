variable "records" {
  type = map(object({
    type   = optional(string, "CNAME")
    ttl    = optional(number, 300)
    record = string
  }))

  description = "object with data for aws_route53_record"

  validation {
    condition     = alltrue([for record_name, record_payload in var.records : contains(["CNAME", "A"], record_payload["type"])])
    error_message = "Only CNAME and A records allowed to provision via module."
  }
}


variable "zone_id" {
  type        = string
  default     = ""
  description = "aws_route53_zone.id"
}

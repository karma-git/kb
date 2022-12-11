variable "source_efs_id" {
  type        = string
  default     = ""
  description = "EFS which needs to be restored"
}

variable "destanation_efs_id" {
  type        = string
  default     = ""
  description = "EFS which restored from backup"
}

variable "subnets" {
  type        = list(string)
  default     = []
  description = "Subnets to which dest EFS should be attached"
}

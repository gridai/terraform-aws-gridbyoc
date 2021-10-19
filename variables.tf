variable "external_id_override" {
  sensitive   = true
  type        = string
  default     = ""
  description = "external id for assume role. If not provided it will be created"
}

variable "grid_account_id" {
  type        = string
  default     = "302180240179"
  description = "Grid'a AWS account"
}

variable "extra_assume_role_arn" {
  type        = list(string)
  default     = []
  description = "[Advance]\nAny extra AWS Principal who can assume this role knowing external ID"
}

variable "extra_assume_role_without_external_id_arn" {
  type        = list(string)
  default     = []
  description = "[Advance]\n[DANGEROUS]\nAny extra AWS Principal who can assume this role without external ID"
}

variable "role_name" {
  type = string
  default = null
}

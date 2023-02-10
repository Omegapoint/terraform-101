variable "project" {
  type        = string
  description = "ProjectTerraJonathan"
  default     = "JOnathanFormTerra2"
}

variable "location" {
  type        = string
  description = "Region to deploy to"
  default     = "northeurope"
}

variable "secret_value" {
  type        = string
  sensitive   = true
  default     = "secret"
  description = "Your super secret value"
}

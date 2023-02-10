variable "project" {
  type        = string
  description = "Name of project"
  default     = "jk-terraform-local"
}

variable "location" {
  type        = string
  description = "Region to deploy to"
  default     = "northeurope"
}

variable "secret_value" {
  type        = string
  sensitive   = true
  default     = "omegasecretvalue"
  description = "Your super secret value"
}

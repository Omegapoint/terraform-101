variable "project" {
  type        = string
  description = "Name of project"
  default     = "rawand-local"
}

variable "location" {
  type        = string
  description = "Region to deploy to"
  default     = "northeurope" //westeurope doesn't work
}

variable "secret_value" {
  type        = string
  sensitive   = true
  default     = "secret"
  description = "Your super secret value"
}

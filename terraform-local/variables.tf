variable "project" {
  type        = string
  description = "Name of project"
  default     = "arvids-new-rg-local" //namnge din resursgrupp till exepelvis somethingsomething-local
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

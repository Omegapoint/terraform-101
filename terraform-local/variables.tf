variable "project" {
  type        = string
  description = "Name of project"
  default     = "chris-terratest"
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
  description = "väldigt hemligt att jag dricker öl"
}

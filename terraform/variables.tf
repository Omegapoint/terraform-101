variable "project" {
    type = string
    description = "tomat"
}

variable "location" {
    type = string
    description = "Region to deploy to"
}

variable "secret_value" {
    type = string
    sensitive = true
    description = "Your super secret value"
}
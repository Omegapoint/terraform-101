variable "project" {
    type = string
    description = "Name of project"
}

variable "location" {
    type = string
    description = "Region to deploy to"
}

variable "secret" {
    type = string
    sensitive = true
    description = "Your super secret value"
}
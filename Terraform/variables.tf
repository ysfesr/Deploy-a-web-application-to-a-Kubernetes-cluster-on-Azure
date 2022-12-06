variable "subscription_id" {
  type        = string
}

variable "client_id" {
  type        = string
}

variable "client_secret" {
  type        = string
}

variable "tenant_id" {
  type        = string
}

variable "jenkins_vm_size" {
  type        = string
  description = "The size of the Jenkins VM"
  default     = "Standard_DS2_v2"
}

variable "location" {
  type        = string
  description = "The location of the Jenkins VM"
  default     = "westeurope"
}
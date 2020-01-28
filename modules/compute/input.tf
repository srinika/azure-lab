variable "name" {
  description = "Name of the azure virtual machine resource"
}

# variable "private_nic" {
#   type = "string"
# }

# variable "public_nic" {
#   type = "string"
# }

variable "nic_ids" {
  type = "list"
  description = "List of network interface card resources"
}


variable "resource_group_name" {
  default = "azure-lab-demo"
}

variable "resource_group_location" {
  default = "australiaeast"
}

variable "default_tags" {
  type = "map"
  default = {environment = "Demo"}
}

variable "dependency" {
  default = []
  description = "Variable to handle the custom module dependencies"
}
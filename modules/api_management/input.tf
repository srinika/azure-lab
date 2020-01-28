variable "name" {
    description = "Name of the api gw instance."
}

variable "resource_group_name" {
  description = "Default resource group name that the network will be created in."
}

variable "resource_group_location" {
  description = "The location/region where the core network will be created."
}

variable "sku" {
  description = "sku type to be used on the api gw instance."
}

variable "publisher" {
  description = "Name of the publisher of the api gw instance."
}

variable "publisher_email" {
  description = "Email of the publisher of the api gw instance."
}

variable "hostname" {
}


variable "tags" {
  description = "The tags to associate with your api gw instance."

  type    = "map"
  default = { environment = "development" }
}
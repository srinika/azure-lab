variable "resource_group_name" {
  default = ""
}

variable "resource_group_location" {
  default = "australiaeast"
}

variable "default_tags" {
  type    = "map"
  default = { environment = "Demo" }
}

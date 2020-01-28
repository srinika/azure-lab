variable "name" {
    description = "Name of the seacrh service."
}

variable "resource_group_name" {
  description = "Default resource group name that the network will be created in."
}

variable "resource_group_location" {
  description = "The location/region where the core network will be created."
}

variable "sku" {
  description = "sku type to be used on the search service."
}

variable "tags" {
  description = "The tags to associate with your search service."

  type    = "map"
  default = { environment = "development" }
}
resource "azurerm_search_service" "search" {
  name                = "${var.name}"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.resource_group_location}"
  sku                 = "${var.sku}"

  tags = "${var.tags}"
}

output "id" {
  value = "${azurerm_search_service.search.id}"
}

output "primary_key" {
  value = "${azurerm_search_service.search.primary_key}"
}

output "secondary_key" {
  value = "${azurerm_search_service.search.secondary_key}"
}

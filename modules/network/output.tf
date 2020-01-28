output "subnet_ids" {
  value = "${azurerm_subnet.subnet.*.id}"
}

output "subnet_names" {
  value = "${azurerm_subnet.subnet.*.name}"
}

output "network_id" {
  value = "${azurerm_virtual_network.network.id}"
}


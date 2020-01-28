# resource "azurerm_subnet" "azure_lab_demo_gateway_subnet" {
#   name                 = "GatewaySubnet"
#   resource_group_name  = "${var.resource_group_name}"
#   virtual_network_name = "${azurerm_virtual_network.azure_lab_dev_demo_network.name}"
#   address_prefix       = "10.0.200.0/27"
#   # network_security_group_id = "${azurerm_network_security_group.azure_lab_demo_nsg.id}"
# }
# resource "azurerm_subnet" "azure_lab_demo_public_subnet" {
#   name                      = "Public"
#   resource_group_name       = "${var.resource_group_name}"
#   virtual_network_name      = "${azurerm_virtual_network.azure_lab_dev_demo_network.name}"
#   address_prefix            = "10.0.2.0/24"
#   network_security_group_id = "${azurerm_network_security_group.azure_lab_demo_nsg.id}"
# }

# resource "azurerm_subnet" "azure_lab_demo_private_subnet" {
#   name                      = "Private"
#   resource_group_name       = "${var.resource_group_name}"
#   virtual_network_name      = "${azurerm_virtual_network.azure_lab_dev_demo_network.name}"
#   address_prefix            = "10.0.1.0/24"
#   network_security_group_id = "${azurerm_network_security_group.azure_lab_demo_nsg.id}"
# }

resource "azurerm_subnet" "subnet" {
  count                = "${length(var.subnet_names)}"
  name                 = "${var.subnet_names[count.index]}"
  virtual_network_name = "${azurerm_virtual_network.network.name}"
  resource_group_name  = "${var.resource_group_name}"
  address_prefix       = "${var.subnet_prefixes[count.index]}"
}
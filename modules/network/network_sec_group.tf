resource "azurerm_network_security_group" "azure_lab_demo_nsg" {
  name                = "azure-lab-demo-nsg-1"
  location            = "${var.resource_group_location}"
  resource_group_name = "${var.resource_group_name}"

  security_rule {
    name                       = "RDP-Srinika-Home"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "219.88.235.97/32"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "HTTP-AZURE-LAB-LB"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "Internet"
    destination_address_prefix = "VirtualNetwork"
  }

  tags = "${var.default_tags}"
}

variable "name" {
}

variable "resource_group_name" {
}

variable "resource_group_location" {
}

variable "subnet_id" {
  type = "string"
}

variable "type" {
  default = "private"
}

variable "public_ip_address_allocation" {
  default = "Dynamic"
}

variable "private_ip_address_allocation" {
  default = "Dynamic"
}


variable "default_tags" {
  type    = "map"
  default = { environment = "Demo" }
}

variable "dependency" {
  default = []
}

resource "null_resource" "dependency" {
  triggers = {
    dependency = "${join("", var.dependency)}"
  }
}

resource "azurerm_public_ip" "nic_public_ip" {
  count                        = "${var.type == "public" ? 1 : 0}"
  name                         = "nic-subnet-${var.subnet_id}"
  location                     = "${var.resource_group_location}"
  resource_group_name          = "${var.resource_group_name}"
  public_ip_address_allocation = "${var.public_ip_address_allocation}"
  tags                         = "${var.default_tags}"
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.name}"
  location            = "${var.resource_group_location}"
  resource_group_name = "${var.resource_group_name}"
  # network_security_group_id = "${azurerm_network_security_group.azure_lab_demo_nsg.id}"

  ip_configuration {
    name                          = "config"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "${var.private_ip_address_allocation}"
    public_ip_address_id          = "${var.type == "public" ? join("",azurerm_public_ip.nic_public_ip.*.id) : ""}"
  }

  tags = "${var.default_tags}"

  depends_on = ["null_resource.dependency","azurerm_public_ip.nic_public_ip"]
}

# resource "azurerm_network_interface" "azure_lab_demo_private_nic" {
#   name                = "azure-lab-demo-private-nic-1"
#   location            = "${var.resource_group_location}"
#   resource_group_name = "${var.resource_group_name}"
#   # network_security_group_id = "${azurerm_network_security_group.azure_lab_demo_nsg.id}"

#   ip_configuration {
#     name                          = "network-config-1"
#     subnet_id                     = "${azurerm_subnet.azure_lab_demo_private_subnet.id}"
#     private_ip_address_allocation = "Dynamic"
#   }

#   tags = "${var.default_tags}"
# }

# resource "azurerm_network_interface_backend_address_pool_association" "test" {
#   network_interface_id    = "${azurerm_network_interface.azure_lab_demo_private_nic.id}"
#   ip_configuration_name   = "network-config-1"
#   backend_address_pool_id = "${azurerm_lb_backend_address_pool.azure_lab_demo_backend_pool.id}"
# }

# resource "azurerm_network_interface_nat_rule_association" "nat_rule" {
#   count = "${length(var.nat_rules)}"
#   network_interface_id  = "${azurerm_network_interface.azure_lab_demo_private_nic.id}"
#   ip_configuration_name = "network-config-1"
#   nat_rule_id           = "${element(var.nat_rules, count.index)}"
# }

# resource "azurerm_network_interface_nat_rule_association" "nat_rule_2" {
#   network_interface_id  = "${azurerm_network_interface.azure_lab_demo_private_nic.id}"
#   ip_configuration_name = "network-config-1"
#   nat_rule_id           = "${azurerm_lb_nat_rule.azure_lab_demo_nat_rule2.id}"
# }

# resource "azurerm_public_ip" "azure_lab_demo_public_ip_nic" {
#   name                = "azure-lab-demo-publicIp-2"
#   location            = "${var.resource_group_location}"
#   resource_group_name = "${var.resource_group_name}"
#   allocation_method   = "Static"
#   sku                 = "Standard"

#   tags = "${var.default_tags}"
# }

output "public_ip_address" {
  value = "${azurerm_public_ip.nic_public_ip.*.ip_address}"
}

output "private_ip_address" {
  description = "Private ip address"
  value       = "${azurerm_network_interface.nic.*.private_ip_address}"
}

output "id" {
  value = "${azurerm_network_interface.nic.id}"
}

# output "nics" {
#   value = "${map(
#     "private_nic", azurerm_network_interface.azure_lab_demo_private_nic.id,
#     "public_nic", azurerm_network_interface.azure_lab_demo_public_nic.id
#   )}"
# }
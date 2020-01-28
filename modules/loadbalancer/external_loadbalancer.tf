resource "azurerm_lb" "azure_lab_dev_demo_external_lb" {
  name                = "azure-lab-demo-external-lb"
  location            = "${var.resource_group_location}"
  resource_group_name = "${var.resource_group_name}"
  sku                 = "Standard" //needs to be same as the public ip associated to have the same SKU Basic/Standard

  frontend_ip_configuration {
    name                 = "external-lb-publicIp"
    public_ip_address_id = "${azurerm_public_ip.azure_lab_demo_public_lb.id}"

    # No private IP required for Internet-facing LoadBalancers

    # private_ip_address = "${azurerm_subnet.azure_lab_demo_private_subnet.id}"
    # private_ip_address_allocation = "Dynamic"
  }

  tags = "${var.default_tags}"

  depends_on = ["azurerm_public_ip.azure_lab_demo_public_lb"]
}

resource "azurerm_lb_backend_address_pool" "azure_lab_demo_backend_pool" {
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.azure_lab_dev_demo_external_lb.id}"
  name                = "AzureLabDemoBackEndAddressPool"
}

# resource "azurerm_lb_nat_pool" "azure_lab_demo_nat_pool" {
#   resource_group_name            = "${azurerm_resource_group.azure_lab_dev_demo_resource_group.name}"
#   loadbalancer_id                = "${azurerm_lb.azure_lab_dev_demo_external_lb.id}"
#   name                           = "AzureLabDemoNatPool"
#   protocol                       = "Tcp"
#   frontend_port_start            = "80"
#   frontend_port_end              = "81"
#   backend_port                   = "80"
#   frontend_ip_configuration_name = "external-lb-publicIp" 
# }

resource "azurerm_lb_nat_rule" "azure_lab_demo_nat_rule1" {
  resource_group_name            = "${var.resource_group_name}"
  loadbalancer_id                = "${azurerm_lb.azure_lab_dev_demo_external_lb.id}"
  name                           = "NATRule1"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "external-lb-publicIp"
}

resource "azurerm_lb_nat_rule" "azure_lab_demo_nat_rule2" {
  resource_group_name            = "${var.resource_group_name}"
  loadbalancer_id                = "${azurerm_lb.azure_lab_dev_demo_external_lb.id}"
  name                           = "NATRule2"
  protocol                       = "Tcp"
  frontend_port                  = 3389
  backend_port                   = 3389
  frontend_ip_configuration_name = "external-lb-publicIp"
}

# resource "azurerm_lb_probe" "azure_lab_demo_http_probe" {
#   resource_group_name = "${azurerm_resource_group.azure_lab_dev_demo_resource_group.name}"
#   loadbalancer_id     = "${azurerm_lb.azure_lab_dev_demo_external_lb.id}"
#   name                = "iis-health-probe"
#   port                = 80

#   depends_on = ["azurerm_lb.azure_lab_dev_demo_external_lb"]
# }

# resource "azurerm_lb_probe" "azure_lab_demo_rdp_probe" {
#   resource_group_name = "${azurerm_resource_group.azure_lab_dev_demo_resource_group.name}"
#   loadbalancer_id     = "${azurerm_lb.azure_lab_dev_demo_external_lb.id}"
#   name                = "rdp-health-probe"
#   port                = 3389

#   depends_on = ["azurerm_lb.azure_lab_dev_demo_external_lb"]
# }

# resource "azurerm_lb_rule" "azure_lab_demo_lb_rule_1" {
#   resource_group_name            = "${azurerm_resource_group.azure_lab_dev_demo_resource_group.name}"
#   loadbalancer_id                = "${azurerm_lb.azure_lab_dev_demo_external_lb.id}"
#   name                           = "LBRule-1"
#   protocol                       = "Tcp"
#   frontend_port                  = 80
#   backend_port                   = 80
#   backend_address_pool_id        = "${azurerm_lb_backend_address_pool.azure_lab_demo_backend_pool.id}"
#   frontend_ip_configuration_name = "external-lb-publicIp"
#   probe_id                       = "${azurerm_lb_probe.azure_lab_demo_http_probe.id}"
#   depends_on                     = ["azurerm_lb_probe.azure_lab_demo_http_probe"]
# }

# resource "azurerm_lb_rule" "azure_lab_demo_lb_rule_2" {
#   resource_group_name            = "${azurerm_resource_group.azure_lab_dev_demo_resource_group.name}"
#   loadbalancer_id                = "${azurerm_lb.azure_lab_dev_demo_external_lb.id}"
#   name                           = "LBRule-2"
#   protocol                       = "Tcp"
#   frontend_port                  = 3389
#   backend_port                   = 3389
#   backend_address_pool_id        = "${azurerm_lb_backend_address_pool.azure_lab_demo_backend_pool.id}"
#   frontend_ip_configuration_name = "external-lb-publicIp"
#   probe_id                       = "${azurerm_lb_probe.azure_lab_demo_rdp_probe.id}"
#   depends_on                     = ["azurerm_lb_probe.azure_lab_demo_rdp_probe"]
# }

resource "azurerm_public_ip" "azure_lab_demo_public_lb" {
  name                = "azure-lab-demo-publicIp-1"
  location            = "${var.resource_group_location}"
  resource_group_name = "${var.resource_group_name}"
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "azurelabdemoiis"

  tags = "${var.default_tags}"
}

data "azurerm_public_ip" "azure_lab_demo_public_ip_lb" {
  name                = "${azurerm_public_ip.azure_lab_demo_public_lb.name}"
  resource_group_name = "${var.resource_group_name}"
}

output "public_ip_address_lb" {
  value = "${data.azurerm_public_ip.azure_lab_demo_public_ip_lb.ip_address}"
}

output "backend_ip_config" {
  value = "${azurerm_lb_backend_address_pool.azure_lab_demo_backend_pool.backend_ip_configurations}"
}

output "lb_rules" {
  value = "${azurerm_lb_backend_address_pool.azure_lab_demo_backend_pool.load_balancing_rules}"
}

output "nat_rules" {
  value = "${list(azurerm_lb_nat_rule.azure_lab_demo_nat_rule1.id, azurerm_lb_nat_rule.azure_lab_demo_nat_rule2.id)}"
}

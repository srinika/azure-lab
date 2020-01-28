resource "azurerm_resource_group" "azure_lab_demo_resource_group" {
  name     = "azure-lab"
  location = "Australia East"

  tags = {
    environement = "development"
  }
}

module "compute" {
  source = "./modules/compute"

  name = "LAB-VM-01"
  resource_group_name = "${azurerm_resource_group.azure_lab_demo_resource_group.name}"
  resource_group_location = "${azurerm_resource_group.azure_lab_demo_resource_group.location}"
  # private_nic = "${module.network.private_nic}"
  # public_nic = "${module.network.public_nic}"
  nic_ids = ["${module.private_subnet_nic.id}"]
  dependency = ["azurerm_resource_group.azure_lab_demo_resource_group"]
  # depends_on = ["azurerm_resource_group.azure_lab_demo_resource_group"]
}

module "iis_server" {
  source = "./modules/extensions/iis"
  
  vm_name = "${module.compute.vm_name}"
  resource_group_name = "${azurerm_resource_group.azure_lab_demo_resource_group.name}"
  resource_group_location = "${azurerm_resource_group.azure_lab_demo_resource_group.location}"
  dependency = ["${module.compute.vm_name}"]
}

module "network" {
  source = "./modules/network"
  
  name = "azure-lab-demo-vnet"
  resource_group_name = "${azurerm_resource_group.azure_lab_demo_resource_group.name}"
  resource_group_location = "${azurerm_resource_group.azure_lab_demo_resource_group.location}"
  address_space       = "10.10.0.0/16"
  subnet_prefixes     = ["10.10.10.0/24", "10.10.20.0/24", "10.10.200.0/28"]
  subnet_names        = ["Private", "Public", "GatewaySubnet"]

  # nat_rules = "${module.loadbalancer.nat_rules}"
  dependency = ["azurerm_resource_group.azure_lab_demo_resource_group"]
}

module "private_subnet_nic" {
  source = "./modules/network_interface"
  
  name = "private-nic-1"
  resource_group_name = "${azurerm_resource_group.azure_lab_demo_resource_group.name}"
  resource_group_location = "${azurerm_resource_group.azure_lab_demo_resource_group.location}"
  subnet_id = "${element(module.network.subnet_ids, 0)}"
  dependency = ["azurerm_resource_group.azure_lab_demo_resource_group"]
}

module "loadbalancer" {
  source = "./modules/loadbalancer"
}
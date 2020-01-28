resource "null_resource" "dependency" {
  triggers = {
    dependency = "${join("", var.dependency)}"
  }
}

resource "azurerm_virtual_machine" "azure_lab_demo_vm" {
  name                  = "${var.name}"
  location              = "${var.resource_group_location}"
  resource_group_name   = "${var.resource_group_name}"
  # network_interface_ids = ["${var.private_nic}"]
  network_interface_ids = "${var.nic_ids}"
  vm_size               = "Standard_DS2_v2"
  availability_set_id   = "${azurerm_availability_set.azure_lab_demo_as_1.id}"

  storage_os_disk {
    name              = "os-disk-1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  os_profile {
    computer_name  = "${var.name}"
    admin_username = "azurelabdemoadmin"
    admin_password = "@@Password_123@@"
  }

  # os_profile_linux_config {
  #   disable_password_authentication = true

  #   ssh_keys {
  #     path     = "/home/azurelabdemoadmin/.ssh/authorized_keys"
  #     key_data = "${file("~/.ssh/id_rsa.pem.pub")}"
  #   }
  # }

  os_profile_windows_config {
    provision_vm_agent = true
    # enable_automatic_upgrades = true
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = "${azurerm_storage_account.azure_lab_demo_storage.primary_blob_endpoint}"
  }

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  tags = "${var.default_tags}"

  depends_on = ["null_resource.dependency"]
}

resource "azurerm_availability_set" "azure_lab_demo_as_1" {
  name                         = "azure-lab-demo-availability-set-1"
  location                     = "${var.resource_group_location}"
  resource_group_name          = "${var.resource_group_name}"
  managed                      = true
  platform_fault_domain_count  = 1
  platform_update_domain_count = 1

  tags = "${var.default_tags}"
}

output "vm_name" {
  description = "virtual machine name created"
  value = "${azurerm_virtual_machine.azure_lab_demo_vm.name}"
}

output "vm_id" {
  description = "Virtual machine id created."
  value       = "${azurerm_virtual_machine.azure_lab_demo_vm.*.id}"
}

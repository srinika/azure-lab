resource "random_id" "azure_lab_demo_randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = "${var.resource_group_name}"
  }

  byte_length = 8
}

resource "azurerm_storage_account" "azure_lab_demo_storage" {
  name                     = "diag${random_id.azure_lab_demo_randomId.hex}"
  resource_group_name      = "${var.resource_group_name}"
  location                 = "${var.resource_group_location}"
  account_replication_type = "LRS"
  account_tier             = "Standard"

  tags = {
    environment = "Demo"
  }
}

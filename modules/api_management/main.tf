resource "azurerm_api_management" "api_gw_instance" {
  name                = "${var.name}"
  location            = "${var.resource_group_location}"
  resource_group_name = "${var.resource_group_name}"
  publisher_name      = "${var.publisher}"
  publisher_email     = "${var.publisher_email}"
  
  identity { 
    type = "SystemAssigned" 
  }
  
  sku {
    name     = "${var.sku}"
    capacity = 1
  }

  # hostname_configuration {
  #     proxy {
  #         host_name = "${var.hostname}.azure-api.net"
  #         default_ssl_binding = false
  #     }
  #     scm {
  #         host_name = "${var.hostname}.scm.azure-api.net"
  #     }
  # }

  sign_in {
    enabled = true
  }

  tags = "${var.tags}"
}

resource "null_resource" "dependency" {
  triggers = {
    dependency = "${join("", var.dependency)}"
  }
}
resource "azurerm_virtual_network" "network" {
  name                = "${var.name}"
  address_space       = ["${var.address_space}"]
  location            = "${var.resource_group_location}"
  resource_group_name = "${var.resource_group_name}"

  tags = "${var.default_tags}"

  depends_on = ["null_resource.dependency"]
}

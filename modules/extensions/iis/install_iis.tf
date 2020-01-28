variable "vm_name" {
}

variable "resource_group_name" {
}

variable "resource_group_location" {
}

variable "default_tags" {
  type = "map"
  default = {environment = "Demo"}
}

variable "dependency" {
  default = []
}

resource "null_resource" "dependency" {
  triggers = {
    dependency = "${join("", var.dependency)}"
  }
}

resource "azurerm_virtual_machine_extension" "iis" {
  name = "install-iis"
  resource_group_name = "${var.resource_group_name}"
  location = "${var.resource_group_location}"
  virtual_machine_name = "${var.vm_name}"
  publisher = "Microsoft.Compute"
  type = "CustomScriptExtension"
  type_handler_version = "1.9"

  settings = <<SETTINGS
  {
      "commandToExecute": "powershell Add-WindowsFeature Web-Asp-Net45;Add-WindowsFeature NET-Framework-45-Core;Add-WindowsFeature Web-Net-Ext45;Add-WindowsFeature Web-ISAPI-Ext;Add-WindowsFeature Web-ISAPI-Filter;Add-WindowsFeature Web-Mgmt-Console;Add-WindowsFeature Web-Scripting-Tools;Add-WindowsFeature Search-Service;Add-WindowsFeature Web-Filtering;Add-WindowsFeature Web-Basic-Auth;Add-WindowsFeature Web-Windows-Auth;Add-WindowsFeature Web-Default-Doc;Add-WindowsFeature Web-Http-Errors;Add-WindowsFeature Web-Static-Content;"
  }
  SETTINGS

  tags = "${var.default_tags}"

  depends_on = ["null_resource.dependency"]
}

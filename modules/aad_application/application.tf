resource "azuread_application" "application" {
    name = "${var.app_name}"
    identifier_uris = "${var.app_type != "webapp/api" ? list() : var.identifier_uris}"
    reply_urls = "${var.reply_urls}"
    available_to_other_tenants = "${var.is_multitenant}"
    oauth2_allow_implicit_flow = "${var.allow_implicit_flow}"

    # required_resource_access {
    #   resource_app_id = "00000003-0000-0000-c000-000000000000"

    #   resource_access {
    #     id = "e1fe6dd8-ba31-4d61-89e7-88639da4683d"
    #     type = "Scope"
    #   }
    # }
}

resource "azuread_service_principal" "default" {
  application_id = "${azuread_application.application.application_id}"
}

# output "id" {
#   value = "${azuread_application.application.object_id}"
# }

output "app_id" {
  value = "${azuread_application.application.application_id}"
}

# output "oauth2_permissions" {
#   value = "${azuread_application.application.oauth2_permissions}"
# }

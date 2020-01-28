variable "app_name" {
  
}

variable "identifier_uris" {
  default = []
  description = "List of user-defined URI(s) that identify the application within it's Azuer AD tenant."
}

variable "reply_urls" {
  default = []
  description = "List of URLs that OAuth 2.0 authorization codes and access tokems are sent to."
}

variable "is_multitenant" {
  default = false
}

variable "allow_implicit_flow" {
  default = false
}

variable "app_type" {
}

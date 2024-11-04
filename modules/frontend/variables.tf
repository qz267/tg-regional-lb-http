variable "proxy_name" {
  description = "The name of the HTTP proxy"
  type        = string
}

variable "url_map" {
  description = "The URL map to associate with the proxy"
  type        = string
}

variable "forwarding_rule_name" {
  description = "The name of the forwarding rule"
  type        = string
}

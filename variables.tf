variable "backend_service_name" {
  description = "The name of the backend service"
  type        = string
}

variable "region" {
  description = "The region where the load balancer will be created"
  type        = string
  default     = "us-central1"
}

variable "url_map_name" {
  description = "The name of the URL map"
  type        = string
}

variable "proxy_name" {
  description = "The name of the HTTP proxy"
  type        = string
}

variable "forwarding_rule_name" {
  description = "The name of the forwarding rule"
  type        = string
}


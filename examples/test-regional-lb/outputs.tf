output "forwarding_rule_ip" {
  description = "The IP address of the forwarding rule"
  value       = module.frontend.forwarding_rule_ip
}

output "backend_service_name" {
  description = "The name of the backend service"
  value       = module.backend.backend_service_name
}

output "proxy_name" {
  description = "The name of the HTTP proxy"
  value       = module.frontend.proxy_name
}

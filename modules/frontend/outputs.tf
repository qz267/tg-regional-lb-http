output "forwarding_rule_ip" {
  description = "The IP address of the forwarding rule"
  value       = google_compute_global_forwarding_rule.default.ip_address
}

output "proxy_name" {
  description = "The name of the HTTP proxy"
  value       = google_compute_target_http_proxy.default.name
}

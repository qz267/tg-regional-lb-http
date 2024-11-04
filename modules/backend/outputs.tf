output "backend_service_name" {
  description = "The name of the backend service"
  value       = google_compute_region_backend_service.default.name
}

output "health_check_name" {
  description = "The name of the health check"
  value       = google_compute_health_check.default.name
}

resource "google_compute_health_check" "default" {
  name               = var.health_check_name
  check_interval_sec = var.check_interval_sec
  timeout_sec        = var.timeout_sec
  healthy_threshold  = var.healthy_threshold
  unhealthy_threshold = var.unhealthy_threshold

  http_health_check {
    port = var.health_check_port
  }
}

resource "google_compute_region_backend_service" "default" {
  name          = var.backend_service_name
  region        = var.region
  protocol      = "HTTP"
  timeout_sec   = 10
  health_checks = [google_compute_health_check.default.self_link]
  backend {
    group = var.instance_group
  }
}

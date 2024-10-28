resource "google_compute_region_backend_service" "default" {
  name        = var.backend_service_name
  region      = var.region
  protocol    = "HTTP"
  timeout_sec = 10
}

resource "google_compute_region_url_map" "default" {
  name            = var.url_map_name
  default_service = google_compute_region_backend_service.default.id
}

resource "google_compute_target_http_proxy" "default" {
  name   = var.proxy_name
  url_map = google_compute_region_url_map.default.id
}

resource "google_compute_global_forwarding_rule" "default" {
  name       = var.forwarding_rule_name
  target     = google_compute_target_http_proxy.default.self_link
  port_range = "80"
}


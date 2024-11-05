resource "google_compute_region_target_http_proxy" "default" {
  region     = var.region
  name    = var.proxy_name
  url_map = var.url_map
}

resource "google_compute_forwarding_rule" "default" {
  name       = var.forwarding_rule_name
  target     = google_compute_region_target_http_proxy.default.self_link
  region     = var.region
  port_range = "80"
}

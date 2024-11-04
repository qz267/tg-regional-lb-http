resource "google_compute_target_http_proxy" "default" {
  name    = var.proxy_name
  url_map = var.url_map
}

resource "google_compute_global_forwarding_rule" "default" {
  name       = var.forwarding_rule_name
  target     = google_compute_target_http_proxy.default.self_link
  port_range = "80"
}

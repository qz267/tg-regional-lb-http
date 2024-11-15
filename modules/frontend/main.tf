/**
 * Copyright 2024 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


locals {
  is_internal = var.load_balancing_scheme == "INTERNAL_SELF_MANAGED"
  address     = var.create_address ? join("", google_compute_address.default[*].address) : var.address

}

### IPv4 ###
resource "google_compute_forwarding_rule" "default" {
  provider   = google-beta
  project    = var.project_id
  name       = "${var.name}-forwarding-rule-http"
  target     = google_compute_region_target_http_proxy.default.self_link
  region     = var.region
  port_range = "80"
}

resource "google_compute_forwarding_rule" "https" {
  name       = "${var.name}-forwarding-rule-https"
  target     = google_compute_region_target_https_proxy.default.self_link
  region     = var.region
  port_range = "443"
}

resource "google_compute_address" "default" {
  provider   = google-beta
  region     = var.region
  count      = local.is_internal ? 0 : var.create_address ? 1 : 0
  project    = var.project_id
  name       = "${var.name}-address"
  ip_version = "IPV4"
  labels     = var.labels
}

resource "google_compute_region_url_map" "default" {
  name            = "${var.name}-region-url-map"
  region          = var.region
  default_service = var.backend_service_self_link
}

resource "google_compute_region_target_http_proxy" "default" {
  name    = "${var.name}-region-http-proxy"
  region  = var.region
  url_map = google_compute_region_url_map.default.self_link
}

resource "google_compute_region_target_https_proxy" "default" {
  name             = "${var.name}-region-https-proxy"
  region           = var.region
  url_map          = google_compute_region_url_map.default.self_link
  ssl_certificates = [var.ssl_certificate]
}


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
  #internal_network = local.is_internal ? var.network : null


  #url_map             = var.create_url_map ? join("", google_compute_region_url_map.default[*].self_link) : var.url_map_resource_uri
  #create_http_forward = var.http_forward || var.https_redirect

  # Create a map with hosts as keys and empty lists as initial values
  hosts = toset([for service in var.url_map_input : service.host])
  backend_services_by_host = {
    for host in local.hosts :
    host => {
      for s in var.url_map_input :
      s.path => s.backend_service if s.host == host
    }
  }
}

### IPv4 ###
resource "google_compute_forwarding_rule" "default" {
  provider              = google-beta
  project               = var.project_id
  region                = var.region
  name                  = "${var.name}-forwarding-rule-http"
  target                = google_compute_region_target_http_proxy.default.self_link
  port_range            = "80"
  ip_address            = local.address
  load_balancing_scheme = var.load_balancing_scheme
  ip_protocol           = "TCP"
  network               = var.network
}

resource "google_compute_forwarding_rule" "https" {
  name                  = "${var.name}-forwarding-rule-https"
  count                 = var.ssl ? 1 : 0
  target                = google_compute_region_target_https_proxy.default[*].self_link
  port_range            = "443"
  load_balancing_scheme = var.load_balancing_scheme
}

resource "google_compute_address" "default" {
  provider     = google-beta
  region       = var.region
  count        = local.is_internal ? 0 : var.create_address ? 1 : 0
  project      = var.project_id
  name         = "${var.name}-address"
  ip_version   = "IPV4"
  labels       = var.labels
  network_tier = "PREMIUM"
  address_type = "EXTERNAL"
}

resource "google_compute_region_url_map" "default" {
  name            = "${var.name}-url-map-default"
  default_service = local.backend_services_by_host["*"]["/*"]
  region          = var.region
}

resource "google_compute_region_target_http_proxy" "default" {
  name    = "${var.name}-region-http-proxy"
  region  = var.region
  url_map = google_compute_region_url_map.default.self_link
}

resource "google_compute_region_target_https_proxy" "default" {
  count            = var.ssl ? 1 : 0
  name             = "${var.name}-region-https-proxy"
  region           = var.region
  url_map          = google_compute_region_url_map.default.self_link
  ssl_certificates = compact(concat(var.ssl_certificates, google_compute_ssl_certificate.default[*].self_link, google_compute_managed_ssl_certificate.default[*].self_link, ), )
}

resource "google_compute_ssl_certificate" "default" {
  project     = var.project_id
  count       = var.ssl && var.create_ssl_certificate ? 1 : 0
  name_prefix = "${var.name}-certificate-"
  private_key = var.private_key
  certificate = var.certificate

  lifecycle {
    create_before_destroy = true
  }
}

resource "random_id" "certificate" {
  count       = var.random_certificate_suffix == true ? 1 : 0
  byte_length = 4
  prefix      = "${var.name}-cert-"

  keepers = {
    domains = join(",", var.managed_ssl_certificate_domains)
  }
}

resource "google_compute_managed_ssl_certificate" "default" {
  provider = google-beta
  project  = var.project_id
  count    = var.ssl && length(var.managed_ssl_certificate_domains) > 0 ? 1 : 0
  name     = var.random_certificate_suffix == true ? random_id.certificate[0].hex : "${var.name}-cert"

  lifecycle {
    create_before_destroy = true
  }

  managed {
    domains = var.managed_ssl_certificate_domains
  }
}

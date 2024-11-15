/**
 * Copyright 2022 Google LLC
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
  url_map = var.create_url_map ? join("", google_compute_region_url_map.default[*].self_link) : var.url_map
}


resource "google_compute_region_backend_service" "default" {
  provider    = google-beta
  name        = "${var.name}-backend-service"
  region      = var.region
  project     = var.project
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 10
}

resource "google_compute_region_url_map" "default" {
  provider        = google-beta
  project         = var.project
  count           = var.create_url_map ? 1 : 0
  name            = "${var.name}-url-map"
  default_service = google_compute_region_backend_service.default.self_link
}

resource "google_compute_region_url_map" "https_redirect" {
  project = var.project
  count   = var.https_redirect ? 1 : 0
  name    = "${var.name}-https-redirect"
  default_url_redirect {
    https_redirect         = true
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    strip_query            = false
  }
}

resource "google_compute_region_target_http_proxy" "default" {
  project = var.project
  name    = "${var.name}region-http-proxy"
  region  = var.region
  url_map = var.https_redirect == false ? local.url_map : join("", google_compute_region_url_map.https_redirect[*].self_link)
}

resource "google_compute_region_target_https_proxy" "default" {
  project          = var.project
  count            = var.ssl ? 1 : 0
  name             = "${var.name}-https-proxy"
  url_map          = local.url_map
  ssl_certificates = compact(concat(var.ssl_certificates, google_compute_ssl_certificate.default[*].self_link, google_compute_managed_ssl_certificate.default[*].self_link, ), )
  ssl_policy       = var.ssl_policy
}

resource "google_compute_ssl_certificate" "default" {
  project     = var.project
  count       = var.ssl && var.create_ssl_certificate ? 1 : 0
  name_prefix = "${var.name}-certificate-"
  private_key = var.private_key
  certificate = var.certificate

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_forwarding_rule" "default" {
  provider   = google-beta
  name       = "${var.name}-forwarding_rule"
  project    = var.project
  target     = google_compute_region_target_http_proxy.default.self_link
  region     = var.region
  port_range = "80"
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
  project  = var.project
  count    = var.ssl && length(var.managed_ssl_certificate_domains) > 0 ? 1 : 0
  name     = var.random_certificate_suffix == true ? random_id.certificate[0].hex : "${var.name}-cert"

  lifecycle {
    create_before_destroy = true
  }

  managed {
    domains = var.managed_ssl_certificate_domains
  }
}

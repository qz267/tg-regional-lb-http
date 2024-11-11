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

resource "google_compute_region_backend_service" "default" {
  name        = var.backend_service_name
  region      = var.region
  protocol    = "HTTP"
  timeout_sec = 10
}

resource "google_compute_region_url_map" "default" {
  name            = "${var.name}-url-map"
  default_service = google_compute_region_backend_service.default.id
}

resource "google_compute_region_target_http_proxy" "default" {
  name    = var.proxy_name
  region  = var.region
  url_map = var.url_map
}

resource "google_compute_forwarding_rule" "default" {
  name       = var.forwarding_rule_name
  target     = google_compute_region_target_http_proxy.default.self_link
  region     = var.region
  port_range = "80"
}


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

resource "google_compute_health_check" "default" {
  name                = var.health_check_name
  check_interval_sec  = var.check_interval_sec
  timeout_sec         = var.timeout_sec
  healthy_threshold   = var.healthy_threshold
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

resource "google_compute_firewall" "allow_health_check" {
  name    = "allow-health-check"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = [var.health_check_port]
  }

  source_ranges = [
    "130.211.0.0/22",
    "35.191.0.0/16"
  ]
  target_tags = [var.instance_group_tag]
}

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

provider "google" {
  project = var.project_id
}

resource "google_compute_network" "default" {
  name                    = "lb-network"
  auto_create_subnetworks = "false"
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "default" {
  name                     = "backend-subnet"
  ip_cidr_range            = "10.1.2.0/24"
  network                  = google_compute_network.default.id
  region                   = var.region
  private_ip_google_access = true

  private_ipv6_google_access = "DISABLE_GOOGLE_ACCESS"
  purpose                    = "PRIVATE"
  stack_type                 = "IPV4_ONLY"
}

resource "google_compute_subnetwork" "proxy-only" {
  name          = "proxy-only-subnet"
  ip_cidr_range = "10.129.0.0/23"
  network       = google_compute_network.default.id
  purpose       = "REGIONAL_MANAGED_PROXY"
  region        = var.region
  role          = "ACTIVE"
}

module "region-lb-http-backend" {
  source            = "../../modules/backend"
  name              = "test-backend-service"
  project_id        = var.project_id
  target_tags       = ["load-balanced-backend"]
  firewall_networks = [google_compute_network.default.name]
  protocol          = "HTTP"
  port_name         = "http"
  timeout_sec       = 10
  enable_cdn        = false
  region            = var.region


  health_check = {
    request_path = "/"
    port         = 80
  }

  groups = [
    {
      group           = google_compute_instance_group_manager.default.instance_group
      capacity_scaler = 1.0
      balancing_mode  = "UTILIZATION"
    },
  ]
}

module "region-lb-http-frontend" {
  source                = "../../modules/frontend"
  project_id            = var.project_id
  name                  = "test-regional-lb-frontend"
  url_map_input         = module.region-lb-http-backend.backend_service_info
  region                = var.region
  load_balancing_scheme = "EXTERNAL_MANAGED"
  network               = google_compute_network.default.id

  backend_service_default_id = module.region-lb-http-backend.backend_service_default_id
}

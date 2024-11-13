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
  region  = var.region
}

module "backend" {
  source               = "../../modules/backend"
  backend_service_name = "test-backend-service"
  region               = var.region
  health_check_name    = "test-health-check"
}

module "frontend" {
  source               = "../../modules/frontend"
  proxy_name           = "test-http-proxy"
  url_map              = module.backend.backend_service_name
  forwarding_rule_name = "test-forwarding-rule"
}

resource "google_compute_instance_template" "default" {
  name_prefix  = "test-template-"
  machine_type = "e2-medium"

  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network = "default"
    access_config {}
  }
}

resource "google_compute_region_instance_group_manager" "default" {
  name               = "test-mig"
  region             = var.region
  base_instance_name = "test-instance"
  version {
    instance_template = google_compute_instance_template.default.self_link
  }
  target_size = 3
}

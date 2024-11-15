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

resource "google_compute_network" "default" {
  name                    = "test-regional-lb-network"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "default" {
  name                     = "test-regional-lb-subnetwork"
  ip_cidr_range            = "10.126.0.0/20"
  network                  = google_compute_network.default.self_link
  region                   = var.region
  private_ip_google_access = true
}

module "backend" {
  source               = "../../modules/backend"
  backend_service_name = "test-backend-service"
  instance_group       = module.mig.instance_group
  project_id           = var.project_id
  region               = var.region
  target_tags          = ["test-regional-lb-subnetwork"]
}

module "frontend" {
  source                    = "../../modules/frontend"
  name                      = "test-regional-lb-frontend"
  backend_service_self_link = module.backend.backend_service_self_link
}

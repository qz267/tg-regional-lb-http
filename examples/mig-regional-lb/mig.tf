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

provider "google-beta" {
  project = var.project_id
}

data "template_file" "group-startup-script" {
  template = file(format("%s/gceme.sh.tpl", path.module))
  vars = {
    PROXY_PATH = ""
  }
}

module "mig_template" {
  source      = "terraform-google-modules/vm/google//modules/instance_template"
  version     = "~> 12.0"
  name_prefix = "test-regional-lb-mig"
  region      = var.region

  network      = google_compute_network.default.self_link
  subnetwork   = google_compute_subnetwork.default.self_link

  labels = {
    managed-by-cnrm = "true"
  }
  metadata = {
    startup-script = <<EOF
    #! /bin/bash
    sudo apt-get update
    sudo apt-get install apache2 -y
    sudo a2ensite default-ssl
    sudo a2enmod ssl
    vm_hostname="$(curl -H "Metadata-Flavor:Google" \
    http://169.254.169.254/computeMetadata/v1/instance/name)"
    sudo echo "Page served from: $vm_hostname" | \
    tee /var/www/html/index.html
    sudo systemctl restart apache2
    EOF
  }
  service_account = {
    email  = ""
    scopes = ["cloud-platform"]
  }
  #startup_script       = data.template_file.group-startup-script.rendered
  source_image_family  = "ubuntu-2004-lts"
  source_image_project = "ubuntu-os-cloud"
  tags                 = ["load-balanced-backend"]
}

resource "google_compute_instance_group_manager" "default" {
  name = "lb-backend-example"
  zone = "${var.region}-a"
  named_port {
    name = "http"
    port = 80
  }
  version {
    instance_template = module.mig_template.self_link
    name              = "primary"
  }
  base_instance_name = "vm"
  target_size        = 3
}

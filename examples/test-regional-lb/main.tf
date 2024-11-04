provider "google" {
  project = var.project_id
  region  = var.region
}

module "backend" {
  source               = "../../modules/backend"
  backend_service_name = "test-backend-service"
  region               = var.region
  instance_group       = google_compute_region_instance_group_manager.default.instance_group
  health_check_name    = "test-health-check"
}

module "frontend" {
  source              = "../../modules/frontend"
  proxy_name          = "test-http-proxy"
  url_map             = module.backend.backend_service_name
  forwarding_rule_name = "test-forwarding-rule"
}

resource "google_compute_instance_template" "default" {
  name_prefix   = "test-template-"
  machine_type  = "e2-medium"

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

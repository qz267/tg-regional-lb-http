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

output "forwarding_rule_ip" {
  description = "The IP address of the forwarding rule"
  value       = google_compute_global_forwarding_rule.default.ip_address
}

output "backend_service_name" {
  description = "The name of the backend service"
  value       = google_compute_region_backend_service.default.name
}

output "url_map_name" {
  description = "The name of the URL map"
  value       = google_compute_region_url_map.default.name
}

output "proxy_name" {
  description = "The name of the HTTP proxy"
  value       = google_compute_target_http_proxy.default.name
}


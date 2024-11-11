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

variable "name" {
  description = "Name for the forwarding rule and prefix for supporting resources"
  type        = string
}

variable "backend_service_name" {
  description = "The name of the backend service"
  type        = string
}

variable "region" {
  description = "The region where the load balancer will be created"
  type        = string
  default     = "us-central1"
}

variable "url_map" {
  description = "The URL map to associate with the proxy"
  type        = string
}

variable "proxy_name" {
  description = "The name of the HTTP proxy"
  type        = string
}

variable "forwarding_rule_name" {
  description = "The name of the forwarding rule"
  type        = string
}


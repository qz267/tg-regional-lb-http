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

variable "name" {
  description = "Name for the forwarding rule and prefix for supporting resources"
  type        = string
}

variable "project_id" {
  description = "The project to deploy to, if not set the default provider project is used."
  type        = string
}

variable "region" {
  description = "The region where the load balancer will be created"
  type        = string
  default     = "us-central1"
}

variable "create_address" {
  type        = bool
  description = "Create a new global IPv4 address"
  default     = true
}

variable "address" {
  type        = string
  description = "Existing IPv4 address to use (the actual IP address value)"
  default     = null
}

variable "labels" {
  description = "The labels to attach to resources created by this module"
  type        = map(string)
  default     = {}
}

variable "load_balancing_scheme" {
  description = "Load balancing scheme type (EXTERNAL for classic external load balancer, EXTERNAL_MANAGED for Envoy-based load balancer, and INTERNAL_SELF_MANAGED for traffic director)"
  type        = string
  default     = "EXTERNAL_MANAGED"
}

variable "ssl" {
  description = "Set to `true` to enable SSL support. If `true` then at least one of these are required: 1) `ssl_certificates` OR 2) `create_ssl_certificate` set to `true` and `private_key/certificate` OR  3) `managed_ssl_certificate_domains`, OR 4) `certificate_map`"
  type        = bool
  default     = false
}

variable "create_ssl_certificate" {
  description = "If `true`, Create certificate using `private_key/certificate`"
  type        = bool
  default     = false
}

variable "private_key" {
  description = "Content of the private SSL key. Requires `ssl` to be set to `true` and `create_ssl_certificate` set to `true`"
  type        = string
  default     = null
}

variable "certificate" {
  description = "Content of the SSL certificate. Requires `ssl` to be set to `true` and `create_ssl_certificate` set to `true`"
  type        = string
  default     = null
}

variable "ssl_certificates" {
  description = "SSL cert self_link list. Requires `ssl` to be set to `true`"
  type        = list(string)
  default     = []
}

variable "managed_ssl_certificate_domains" {
  description = "Create Google-managed SSL certificates for specified domains. Requires `ssl` to be set to `true`"
  type        = list(string)
  default     = []
}

variable "random_certificate_suffix" {
  description = "Bool to enable/disable random certificate name generation. Set and keep this to true if you need to change the SSL cert."
  type        = bool
  default     = false
}

variable "url_map_input" {
  description = "List of host, path and backend service for creating url_map"
  type = list(object({
    host            = string
    path            = string
    backend_service = string
  }))
  default = []
}

variable "network" {
  description = "Network for INTERNAL_SELF_MANAGED load balancing scheme"
  type        = string
  default     = "default"
}
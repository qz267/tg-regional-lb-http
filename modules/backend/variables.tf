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

variable "backend_service_name" {
  description = "The name of the backend service"
  type        = string
}

variable "project_id" {
  description = "The project to deploy to, if not set the default provider project is used."
  type        = string
}

variable "region" {
  description = "The region for the backend service"
  type        = string
}

variable "instance_group" {
  description = "The instance group used for the backend service"
  type        = string
}

variable "check_interval_sec" {
  description = "Interval in seconds between health checks"
  type        = number
  default     = 5
}

variable "timeout_sec" {
  description = "Timeout in seconds for each health check"
  type        = number
  default     = 5
}

variable "health_check" {
  description = "Input for creating HttpHealthCheck or HttpsHealthCheck resource for health checking this BackendService. A health check must be specified unless the backend service uses an internet or serverless NEG as a backend."
  type = object({
    host                = optional(string, null)
    request_path        = optional(string, null)
    request             = optional(string, null)
    response            = optional(string, null)
    port                = optional(number, null)
    port_name           = optional(string, null)
    proxy_header        = optional(string, null)
    port_specification  = optional(string, null)
    protocol            = optional(string, null)
    check_interval_sec  = optional(number, 5)
    timeout_sec         = optional(number, 5)
    healthy_threshold   = optional(number, 2)
    unhealthy_threshold = optional(number, 2)
    logging             = optional(bool, false)
  })
  default = null
}

variable "healthy_threshold" {
  description = "Number of consecutive successes required to mark an instance as healthy"
  type        = number
  default     = 2
}

variable "unhealthy_threshold" {
  description = "Number of consecutive failures required to mark an instance as unhealthy"
  type        = number
  default     = 2
}

variable "health_check_port" {
  description = "Port for the health check"
  type        = number
  default     = 80
}

variable "firewall_networks" {
  description = "Names of the networks to create firewall rules in"
  type        = list(string)
  default     = ["default"]
}

variable "firewall_projects" {
  description = "Names of the projects to create firewall rules in"
  type        = list(string)
  default     = ["default"]
}

variable "target_tags" {
  description = "List of target tags for health check firewall rule. Exactly one of target_tags or target_service_accounts should be specified."
  type        = list(string)
  default     = []
}

variable "target_service_accounts" {
  description = "List of target service accounts for health check firewall rule. Exactly one of target_tags or target_service_accounts should be specified."
  type        = list(string)
  default     = []
}

variable "serverless_neg_backends" {
  description = "The list of serverless backend which serves the traffic."
  type = list(object({
    region          = string
    type            = string // cloud-run, cloud-function, and app-engine
    service_name    = string
    service_version = optional(string)
  }))
  default = []
}

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

variable "region" {
  description = "The region for the backend service"
  type        = string
}

variable "instance_group" {
  description = "The instance group used for the backend service"
  type        = string
}

variable "health_check_name" {
  description = "The name of the health check"
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

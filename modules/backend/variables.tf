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

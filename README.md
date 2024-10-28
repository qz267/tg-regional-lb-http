# terraform-google-lb-regional

## Overview

This module provides a Terraform configuration for creating a regional HTTP load
balancer on Google Cloud Platform. The regional load balancer distributes
incoming traffic across multiple backends, ensuring high availability and
scalability for applications deployed within a specific region. The module is
designed to work with Managed Instance Groups (MIGs) as backends, providing
flexibility in managing the underlying compute resources.

## Features

-   Regional HTTP load balancer
-   Managed Instance Group (MIG) as backend
-   Configurable health checks
-   Regional URL map and forwarding rule setup
-   Easy integration with other Google Cloud resources

## Usage

```hcl
module "mig_backend_regional_lb" {
  source = "github.com/qz267/tg-regional-lb-http"

  backend_service_name  = "example-bjkackend-service"
  region                = "us-central1"
  url_map_name          = "example-url-map"
  proxy_name            = "example-proxy"
  forwarding_rule_name  = "example-forwarding-rule"
}
```

## Inputs

| Name                  | Description                                         | Type   | Default       | Required |
|-----------------------|-----------------------------------------------------|--------|---------------|:--------:|
| `backend_service_name`| The name of the backend service                     | string | n/a           | yes      |
| `region`              | The region where the load balancer will be created  | string | `us-central1` | no       |
| `url_map_name`        | The name of the URL map                             | string | n/a           | yes      |
| `proxy_name`          | The name of the HTTP proxy                          | string | n/a           | yes      |
| `forwarding_rule_name`| The name of the forwarding rule                     | string | n/a           | yes      |

## Outputs

Name                 | Description
-------------------- | -------------------------------------
`forwarding_rule_ip` | The IP address of the forwarding rule

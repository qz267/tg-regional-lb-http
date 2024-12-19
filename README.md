# Regional HTTP Load Balancer Terraform Module

Modular Regional HTTP Load Balancer for GCE using forwarding rules.

-   If you would like to allow for backend groups to be managed outside
    Terraform, such as via GKE services, see the [backends](./modules/backends)
    submodule.
-   If you would like to use regional load balancing with serverless backends
    (Cloud Run, Cloud Functions or App Engine), see the
    [frontend](./modules/frontend) submodule.

## Load Balancer Types

-   [TCP load balancer](https://github.com/terraform-google-modules/terraform-google-lb)
-   [HTTP/S global load balancer](https://github.com/terraform-google-modules/terraform-google-lb-http)
-   **HTTP/S reginal load balancer**
-   [Internal load balancer](https://github.com/terraform-google-modules/terraform-google-lb-internal)

## Compatibility

This module is meant for use with Terraform 1.3+ and tested using Terraform 1.3.
If you find incompatibilities using Terraform >=1.3, please open an issue. If
you haven't [upgraded](https://www.terraform.io/upgrade-guides/0-13.html) and
need a Terraform 0.12.x-compatible version of this module, the last released
version intended for Terraform 0.12.x is
[v4.5.0](https://registry.terraform.io/modules/GoogleCloudPlatform/lb-http/google/4.5.0).

## Contributing

Refer to the [contribution guidelines](./CONTRIBUTING.md) for information on
contributing to this module.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| address | Existing IPv4 address to use (the actual IP address value) | `string` | `null` | no |
| affinity\_cookie\_ttl\_sec | Lifetime of cookies in seconds if session\_affinity is GENERATED\_COOKIE. | `number` | `null` | no |
| certificate | Content of the SSL certificate. Requires `ssl` to be set to `true` and `create_ssl_certificate` set to `true` | `string` | `null` | no |
| certificate\_map | Certificate Map ID in format projects/{project}/locations/global/certificateMaps/{name}. Identifies a certificate map associated with the given target proxy.  Requires `ssl` to be set to `true` | `string` | `null` | no |
| connection\_draining\_timeout\_sec | Time for which instance will be drained (not accept new connections, but still work to finish started). | `number` | `null` | no |
| create\_address | Create a new global IPv4 address | `bool` | `true` | no |
| create\_ssl\_certificate | If `true`, Create certificate using `private_key/certificate` | `bool` | `false` | no |
| create\_url\_map | Set to `false` if url\_map variable is provided. | `bool` | `true` | no |
| description | Description of the backend service. | `string` | `null` | no |
| enable\_cdn | Enable Cloud CDN for this BackendService. | `bool` | `false` | no |
| firewall\_networks | Names of the networks to create firewall rules in | `list(string)` | <pre>[<br>  "default"<br>]</pre> | no |
| firewall\_projects | Names of the projects to create firewall rules in | `list(string)` | <pre>[<br>  "default"<br>]</pre> | no |
| groups | The list of backend instance group which serves the traffic. | <pre>list(object({<br>    group       = string<br>    description = optional(string)<br><br>    balancing_mode               = optional(string)<br>    capacity_scaler              = optional(number)<br>    max_connections              = optional(number)<br>    max_connections_per_instance = optional(number)<br>    max_connections_per_endpoint = optional(number)<br>    max_rate                     = optional(number)<br>    max_rate_per_instance        = optional(number)<br>    max_rate_per_endpoint        = optional(number)<br>    max_utilization              = optional(number)<br>  }))</pre> | `[]` | no |
| health\_check | Input for creating HttpHealthCheck or HttpsHealthCheck resource for health checking this BackendService. A health check must be specified unless the backend service uses an internet or serverless NEG as a backend. | <pre>object({<br>    host                = optional(string, null)<br>    request_path        = optional(string, null)<br>    request             = optional(string, null)<br>    response            = optional(string, null)<br>    port                = optional(number, null)<br>    port_name           = optional(string, null)<br>    proxy_header        = optional(string, null)<br>    port_specification  = optional(string, null)<br>    protocol            = optional(string, null)<br>    check_interval_sec  = optional(number, 10)<br>    timeout_sec         = optional(number, 10)<br>    healthy_threshold   = optional(number, 2)<br>    unhealthy_threshold = optional(number, 2)<br>    logging             = optional(bool, true)<br>  })</pre> | `null` | no |
| host\_path\_mappings | The list of host/path for which traffic could be sent to the backend service | <pre>list(object({<br>    host = string<br>    path = string<br>  }))</pre> | <pre>[<br>  {<br>    "host": "*",<br>    "path": "/*"<br>  }<br>]</pre> | no |
| http\_forward | Set to `false` to disable HTTP port 80 forward | `bool` | `true` | no |
| http\_keep\_alive\_timeout\_sec | Specifies how long to keep a connection open, after completing a response, while there is no matching traffic (in seconds). | `number` | `null` | no |
| http\_port | The port for the HTTP load balancer | `number` | `80` | no |
| https\_port | The port for the HTTPS load balancer | `number` | `443` | no |
| https\_redirect | Set to `true` to enable https redirect on the lb. | `bool` | `false` | no |
| labels | The labels to attach to resources created by this module | `map(string)` | `{}` | no |
| load\_balancing\_scheme | Load balancing scheme type (EXTERNAL for classic external load balancer, EXTERNAL\_MANAGED for Envoy-based load balancer, and INTERNAL\_SELF\_MANAGED for traffic director) | `string` | `"EXTERNAL_MANAGED"` | no |
| locality\_lb\_policy | The load balancing algorithm used within the scope of the locality. | `string` | `null` | no |
| managed\_ssl\_certificate\_domains | Create Google-managed SSL certificates for specified domains. Requires `ssl` to be set to `true` | `list(string)` | `[]` | no |
| name | Name for the forwarding rule and prefix for supporting resources | `string` | n/a | yes |
| network | Network for INTERNAL\_SELF\_MANAGED load balancing scheme | `string` | `"default"` | no |
| port\_name | Name of backend port. The same name should appear in the instance groups referenced by this service. Required when the load balancing scheme is EXTERNAL. | `string` | `"http"` | no |
| private\_key | Content of the private SSL key. Requires `ssl` to be set to `true` and `create_ssl_certificate` set to `true` | `string` | `null` | no |
| project\_id | The project to deploy to, if not set the default provider project is used. | `string` | n/a | yes |
| protocol | The protocol this BackendService uses to communicate with backends. | `string` | `"HTTP"` | no |
| quic | Specifies the QUIC override policy for this resource. Set true to enable HTTP/3 and Google QUIC support, false to disable both. Defaults to null which enables support for HTTP/3 only. | `bool` | `null` | no |
| random\_certificate\_suffix | Bool to enable/disable random certificate name generation. Set and keep this to true if you need to change the SSL cert. | `bool` | `false` | no |
| region | The region where the load balancer will be created | `string` | `"us-central1"` | no |
| security\_policy | The resource URL for the security policy to associate with the backend service | `string` | `null` | no |
| server\_tls\_policy | The resource URL for the server TLS policy to associate with the https proxy service | `string` | `null` | no |
| serverless\_neg\_backends | The list of serverless backend which serves the traffic. | <pre>list(object({<br>    region          = string<br>    type            = string // cloud-run, cloud-function, and app-engine<br>    service_name    = string<br>    service_version = optional(string)<br>    capacity_scaler = optional(number, 1.0)<br>  }))</pre> | `[]` | no |
| session\_affinity | Type of session affinity to use. Possible values are: NONE, CLIENT\_IP, CLIENT\_IP\_PORT\_PROTO, CLIENT\_IP\_PROTO, GENERATED\_COOKIE, HEADER\_FIELD, HTTP\_COOKIE, STRONG\_COOKIE\_AFFINITY. | `string` | `null` | no |
| ssl | Set to `true` to enable SSL support. If `true` then at least one of these are required: 1) `ssl_certificates` OR 2) `create_ssl_certificate` set to `true` and `private_key/certificate` OR  3) `managed_ssl_certificate_domains`, OR 4) `certificate_map` | `bool` | `false` | no |
| ssl\_certificates | SSL cert self\_link list. Requires `ssl` to be set to `true` | `list(string)` | `[]` | no |
| ssl\_policy | Selfink to SSL Policy | `string` | `null` | no |
| target\_service\_accounts | List of target service accounts for health check firewall rule. Exactly one of target\_tags or target\_service\_accounts should be specified. | `list(string)` | `[]` | no |
| target\_tags | List of target tags for health check firewall rule. Exactly one of target\_tags or target\_service\_accounts should be specified. | `list(string)` | `[]` | no |
| timeout\_sec | This has different meaning for different type of load balancing. Please refer https://cloud.google.com/load-balancing/docs/backend-service#timeout-setting | `number` | `null` | no |
| url\_map\_input | List of host, path and backend service for creating url\_map | <pre>list(object({<br>    host            = string<br>    path            = string<br>    backend_service = string<br>  }))</pre> | `[]` | no |
| url\_map\_resource\_uri | The url\_map resource to use. Default is to send all traffic to first backend. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| backend\_services | The region backend service resources. |
| external\_ip | The external IPv4 assigned to the fowarding rule. |
| http\_proxy | The HTTP proxy used by this module. |
| https\_proxy | The HTTPS proxy used by this module. |
| url\_map | The default URL map used by this module. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


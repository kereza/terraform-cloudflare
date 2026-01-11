# Terraform Cloudflare Module

[![Terraform Version](https://img.shields.io/badge/Terraform-%3E%3D1.5.0-623CE4.svg?logo=terraform)](https://www.terraform.io)
[![Cloudflare Provider](https://img.shields.io/badge/Cloudflare-Provider-4C78C2?logo=cloudflare)](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Release](https://img.shields.io/github/v/release/kereza/terraform-cloudflare?color=green)](https://github.com/kereza/terraform-cloudflare/releases)

Simple Terraform module to quickly set up:

- Cloudflare Tunnel (cloudflared)
- Public Hostname routing
- DNS records
- Optional basic Zero Trust Access application + policy

## Features

- Creates a named Cloudflare Tunnel
- Configures public hostname(s) with service routing
- Automatically creates corresponding CNAME DNS record
- Optional creation of basic Zero Trust Access Application with simple policies

## Requirements

| Requirement          | Version     |
|----------------------|-------------|
| Terraform            | >= 1.5      |
| cloudflare provider  | >= 4.0      |

## Usage

```hcl
module "cloudflare" {
  source = "github.com/kereza/terraform-cloudflare"

  account_id  = "cloudflare_account_id"
  team_name   = "team_name"
  tunnel_name = "Home"

  routes = {
    "home" = "192.168.0.0/24"
  }
  allowed_emails = ["example@gmail.com"]

  main_domain = "example.com"
  public_apps = {
    "example.com"         = "http://192.168.0.163:3600"
    "grafana.example.com" = "http://192.168.0.163:3000"
  }
}

```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | value | `string` | n/a | yes |
| <a name="input_allowed_emails"></a> [allowed\_emails](#input\_allowed\_emails) | A list of emails to define who can join their device to WARP | `list(string)` | n/a | yes |
| <a name="input_custom_addresses"></a> [custom\_addresses](#input\_custom\_addresses) | Additional network addresses to be included in Cloudflare Zero Trust domains<br/>  [<br/>  {<br/>    address = "10.10.10.1/24"<br/>    description = "test"<br/>  }<br/>  ] | `list(map(string))` | `[]` | no |
| <a name="input_custom_hosts"></a> [custom\_hosts](#input\_custom\_hosts) | Additional domains to be included in Cloudflare Zero Trust domains<br/>  [<br/>  {<br/>    host = "test.com"<br/>    description = "test"<br/>  }<br/>  ] | `list(map(string))` | `[]` | no |
| <a name="input_identity_provider"></a> [identity\_provider](#input\_identity\_provider) | The ID provider used. Currently only onetime pin is supported | `string` | `"onetimepin"` | no |
| <a name="input_main_domain"></a> [main\_domain](#input\_main\_domain) | The main domain registered with CloudFlare | `string` | `""` | no |
| <a name="input_public_apps"></a> [public\_apps](#input\_public\_apps) | The domains which will be publicly exposed and the private network address of the apps | `map(string)` | `{}` | no |
| <a name="input_routes"></a> [routes](#input\_routes) | value | `map(string)` | n/a | yes |
| <a name="input_ssh"></a> [ssh](#input\_ssh) | Connect to SSH with client-side cloudflared | `bool` | `false` | no |
| <a name="input_team_name"></a> [team\_name](#input\_team\_name) | Cloud Flare Zero Trust team name. Can not be created automatically. Need to add payment method | `string` | n/a | yes |
| <a name="input_tunnel_name"></a> [tunnel\_name](#input\_tunnel\_name) | The name of the tunnel | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_tunnel_token"></a> [tunnel\_token](#output\_tunnel\_token) | n/a |
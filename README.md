# Terraform Cloudflare Module

[![Terraform Version](https://img.shields.io/badge/Terraform-%3E%3D1.5.0-623CE4.svg?logo=terraform)](https://www.terraform.io)
[![Cloudflare Provider](https://img.shields.io/badge/Cloudflare-Provider-4C78C2?logo=cloudflare)](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Release](https://img.shields.io/github/v/release/kereza/terraform-cloudflare?color=green)](https://github.com/kereza/terraform-cloudflare/releases)

Simple and opinionated Terraform module to quickly set up:

- Cloudflare Tunnel (cloudflared)
- Public Hostname routing
- DNS records (CNAME + optional TXT verification)
- Optional basic Zero Trust Access application + policy

## Features

- Creates a named Cloudflare Tunnel
- Configures public hostname(s) with service routing
- Automatically creates corresponding CNAME DNS record
- Optional TXT record for tunnel verification
- Optional creation of basic Zero Trust Access Application with simple policies

## Requirements

| Requirement          | Version     |
|----------------------|-------------|
| Terraform            | >= 1.5      |
| cloudflare provider  | >= 4.0      |

## Usage

```hcl
module "cloudflare_tunnel" {
  source = "github.com/kereza/terraform-cloudflare"

  tunnel_name        = "my-homelab-tunnel"
  account_id         = "your-cloudflare-account-id"
  zone_id            = "your-zone-id"

  tunnel_target = {
    service = "http"
    url     = "http://192.168.1.100:8080"   # or localhost, internal IP, etc.
  }

  public_hostname = {
    subdomain = "app"
    domain    = "example.com"
  }

  create_verification_txt = true

  create_access_app = true
  access_policies = [
    {
      name     = "Allow team members"
      action   = "allow"
      emails   = ["*@yourcompany.com"]
    }
  ]

  tags = {
    environment = "production"
    project     = "internal-tools"
  }
}

Name,Description,Type,Default,Required
tunnel_name,Human-readable name of the tunnel,string,n/a,yes
account_id,Cloudflare Account ID,string,n/a,yes
zone_id,Zone ID for DNS record creation,string,n/a,yes
tunnel_target,Target service configuration (service + url),map(string),n/a,yes
public_hostname,Public hostname settings (subdomain + domain),map(string),n/a,yes
create_verification_txt,Whether to create TXT verification record,bool,false,no
create_access_app,Create basic Zero Trust Access Application,bool,false,no
access_policies,List of simple Access policies,list(any),[],no
tags,Map of tags to apply to created resources,map(string),{},no
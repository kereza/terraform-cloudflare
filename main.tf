locals {
  # Since INCLUDE mode is being used, the networs provided are additionally included
  default_addresses = [
    for description, address in var.routes : {
      address     = address
      description = description
    }
  ]

  # Since INCLUDE mode is being used, we must include the following domains
  default_hosts = [
    {
      host        = "${var.team_name}.cloudflareaccess.com" ##### Check
      description = "The IdP used to authenticate to Cloudflare Zero Trust"
    },
    {
      host        = "edge.browser.run"
      description = "The application protected by the Access or Gateway policy"
    }
  ]

  allowed_emails_set = join(" ", [
    for email in var.allowed_emails : "\"${email}\""
  ])

  public_apps_format = [
    for hostname, service in var.public_apps : {
      hostname = hostname
      service  = service
    }
  ]
}

resource "cloudflare_zero_trust_tunnel_cloudflared" "tunnel" {
  account_id = var.account_id
  name       = var.tunnel_name
  config_src = "cloudflare"
}

data "cloudflare_zero_trust_tunnel_cloudflared_token" "tunnel" {
  account_id = var.account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.tunnel.id
}


resource "cloudflare_zero_trust_tunnel_cloudflared_route" "route" {
  for_each   = var.routes
  account_id = var.account_id
  network    = each.value
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.tunnel.id
  comment    = each.key
}

resource "cloudflare_zero_trust_device_custom_profile" "custom_profile" {
  account_id  = var.account_id
  match       = "any(identity.groups.email[*] in {${local.allowed_emails_set}})"
  name        = "Main Custom Profile"
  precedence  = 3
  description = "Main Custom Profile"
  include     = concat(local.default_addresses, local.default_hosts, var.custom_addresses, var.custom_hosts)
  enabled     = true
}


resource "cloudflare_zero_trust_access_identity_provider" "identity_provider" {
  config     = {}
  account_id = var.account_id
  name       = "Main IDP"
  type       = var.identity_provider
}

resource "cloudflare_zero_trust_access_policy" "policy" {
  account_id = var.account_id
  decision   = "allow"
  include = [
    for email in var.allowed_emails : {
      email = {
        email = email
      }
    }
  ]
  require = [
    {
      login_method = {
        id = cloudflare_zero_trust_access_identity_provider.identity_provider.id
      }
    }
  ]
  name             = "Main Policy"
  session_duration = "6h"
}

resource "cloudflare_zero_trust_access_application" "access_app" {
  account_id                = var.account_id
  type                      = "warp"
  name                      = "Warp Login App"
  allowed_idps              = [cloudflare_zero_trust_access_identity_provider.identity_provider.id]
  auto_redirect_to_identity = true
  policies = [
    {
      id         = cloudflare_zero_trust_access_policy.policy.id
      precedence = 1
    }
  ]
}

resource "cloudflare_zero_trust_access_application" "ssh" {
  account_id = var.account_id
  type       = "ssh"
  name       = "SSH"
  allowed_idps              = [cloudflare_zero_trust_access_identity_provider.identity_provider.id]
  auto_redirect_to_identity = true
  policies = [
    {
      id         = cloudflare_zero_trust_access_policy.policy.id
      precedence = 1
    }
  ]
  destinations = [
    {
      type = "public"
      uri  = "ssh.${var.main_domain}"
    }
  ]
}


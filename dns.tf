data "cloudflare_zone" "zone" {
  count = var.main_domain == "" ? 0 : 1
  filter = {
    name = var.main_domain
  }
}

resource "cloudflare_zone_setting" "https" {
  count      = var.main_domain == "" ? 0 : 1
  zone_id    = data.cloudflare_zone.zone[0].id
  setting_id = "always_use_https"
  value      = "on"
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "apps" {
  count      = var.main_domain == "" ? 0 : 1
  account_id = var.account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.tunnel.id
  config = {
    ingress = concat(local.public_apps_format, [
      {
        service = "http_status:404"
      }
    ])
  }
}

resource "cloudflare_dns_record" "this" {
  for_each = var.main_domain == "" ? {} : var.public_apps
  zone_id  = data.cloudflare_zone.zone[0].id
  name     = each.key
  ttl      = 1
  type     = "CNAME"
  content  = "${cloudflare_zero_trust_tunnel_cloudflared.tunnel.id}.cfargotunnel.com"
  proxied  = true
}

resource "cloudflare_dns_record" "shh" {
  count = var.ssh ? 1 : 0
  zone_id  = data.cloudflare_zone.zone[0].id
  name     = "ssh.${var.main_domain}"
  ttl      = 1
  type     = "CNAME"
  content  = "${cloudflare_zero_trust_tunnel_cloudflared.tunnel.id}.cfargotunnel.com"
  proxied  = true
}
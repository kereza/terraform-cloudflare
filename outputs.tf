output "tunnel_token" {
  value       = data.cloudflare_zero_trust_tunnel_cloudflared_token.tunnel.token
  sensitive   = true
  description = "The tokne which should be used the cloudflared app is started"
}
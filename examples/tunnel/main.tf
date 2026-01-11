module "cloudflare" {
  source = "../../"

  account_id  = "cloudflare_account_id"
  team_name   = "team_name"
  tunnel_name = "Home"

  routes = {
    "home" = "192.168.0.0/24"
  }
  allowed_emails = ["example@gmail.com"]
}

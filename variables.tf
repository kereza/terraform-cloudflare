variable "account_id" {
  description = "value"
  type        = string
}

variable "tunnel_name" {
  description = "The name of the tunnel"
  type        = string
}

variable "team_name" {
  description = "Cloud Flare Zero Trust team name. Can not be created automatically. Need to add payment method"
  type        = string
}

variable "routes" {
  description = "value"
  type        = map(string)
}

variable "identity_provider" {
  description = "The ID provider used. Currently only onetime pin is supported"
  type        = string
  default     = "onetimepin"
}

variable "custom_addresses" {
  description = <<EOT
  Additional network addresses to be included in Cloudflare Zero Trust domains
  [
  {
    address = "10.10.10.1/24"
    description = "test"
  }
  ]
  EOT
  type        = list(map(string))
  default     = []
}

variable "custom_hosts" {
  description = <<EOT
  Additional domains to be included in Cloudflare Zero Trust domains
  [
  {
    host = "test.com"
    description = "test"
  }
  ]
  EOT
  type        = list(map(string))
  default     = []
}

variable "allowed_emails" {
  description = "A list of emails to define who can join their device to WARP"
  type        = list(string)
}

variable "main_domain" {
  description = "The main domain registered with CloudFlare"
  type        = string
  default     = ""
}

variable "public_apps" {
  description = "The domains which will be publicly exposed and the private network address of the apps"
  type        = map(string)
  default     = {}
}

variable "ssh" {
  description = "Connect to SSH with client-side cloudflared"
  type = bool
  default = false
}
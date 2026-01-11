# Create Cloudflare tunnel and exposes private applications via DNS records

Configuration in this directory creates a CloudFlare tunnel with a random token which can be exposed as output (sensitive value). It allows to add  users (email) which will be able to authenticate via onetime pin. 
The team name need to be created in advance in the CloudFlare UI

The configuration exposes two application running on IP:port and domains

```
public_apps = {
    "example.com"         = "http://192.168.0.163:3600"
    "grafana.example.com" = "http://192.168.0.163:3000"
  }
```
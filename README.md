# nginx-frontproxy

Nginx front proxy for the MediaWiki host. Routes inbound traffic on ports 80 and 443 to the correct backend by HTTP host header (port 80) and TLS SNI (port 443). TLS is **not** terminated here — port 443 traffic is forwarded at the TCP level.

| Traffic | Rule | Backend |
|---|---|---|
| Port 80, `remarkable.brothersbrothers.net` | HTTP host header | rm-sync host |
| Port 80, any other hostname | default | MediaWiki (`localhost:MEDIAWIKI_PORT`) |
| Port 443, SNI `remarkable.brothersbrothers.net` | TLS SNI | rm-sync host |
| Port 443, any other SNI | — | connection closed |

---

## First-time setup

```bash
git clone <repo-url> nginx-frontproxy
cd nginx-frontproxy
cp .env.example .env
# Edit .env — at minimum confirm RMSYNC_IP is correct
make up
```

## Deploying updates

```bash
git pull
make restart   # or: make build && make restart if nginx.conf.template changed
```

## Common commands

```
make up        # start
make down      # stop
make restart   # stop + start
make logs      # tail logs
make validate  # nginx -t inside the running container
make build     # rebuild image (needed after Dockerfile or template changes)
```

## Adding a future HTTPS backend

1. Add an `A` record / DDNS entry for the new subdomain.
2. In `nginx.conf.template`:
   - Add a `server { listen 80; server_name <new-host>; ... }` block in the `http` context.
   - Add a line to the `map` block in the `stream` context: `<new-host>   newservice_443;`
   - Add an `upstream newservice_443 { server <ip>:<port>; }` block.
3. `make restart`

No router changes needed — all inbound 80/443 traffic continues through this proxy.

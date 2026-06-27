#!/bin/sh
set -e

# Substitute environment variables into the nginx config template.
# Only the variables listed here are substituted; all other dollar signs
# (nginx variables like $host, $remote_addr) are left untouched.
envsubst '${RMSYNC_IP} ${RMSYNC_HTTP_PORT} ${RMSYNC_HTTPS_PORT} ${MEDIAWIKI_PORT}' \
    < /etc/nginx/nginx.conf.template \
    > /etc/nginx/nginx.conf

# Validate the generated config before starting.
nginx -t

exec "$@"

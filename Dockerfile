FROM alpine:3.19

# Static site for packwiz modpack
# Coolify will serve /www on the configured domain

RUN apk add --no-cache nginx && \
    mkdir -p /www/mods && \
    rm -rf /etc/nginx/http.d/default.conf

COPY pack.toml /www/
COPY index.toml /www/
COPY packwiz-installer-bootstrap.jar /www/
COPY mods/ /www/mods/

COPY nginx.conf /etc/nginx/http.d/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

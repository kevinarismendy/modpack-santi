FROM alpine:3.19

RUN apk add --no-cache nginx git

# Clone the repo (Coolify build context is empty)
RUN git clone --depth 1 https://github.com/kevinarismendy/modpack-santi.git /tmp/repo && \
    mkdir -p /www/mods && \
    cp /tmp/repo/pack.toml /tmp/repo/index.toml /tmp/repo/packwiz-installer-bootstrap.jar /www/ && \
    cp -r /tmp/repo/mods/* /www/mods/ && \
    rm -rf /etc/nginx/http.d/default.conf && \
    rm -rf /tmp/repo

# Inline nginx.conf (Coolify build context is empty so COPY fails)
RUN cat > /etc/nginx/http.d/default.conf <<'EOF'
server {
    listen 80;
    server_name _;
    root /www;
    autoindex off;

    # Cache busting for TOML files
    location ~* \.(toml|json)$ {
        add_header Cache-Control "no-cache, no-store, must-revalidate";
        add_header Pragma "no-cache";
        add_header Expires "0";
    }

    # Cache the bootstrap jar
    location ~* \.jar$ {
        add_header Cache-Control "public, max-age=3600";
    }

    # Only serve specific file types, 404 for everything else
    location / {
        try_files $uri =404;
    }
}
EOF

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

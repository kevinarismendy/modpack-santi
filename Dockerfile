FROM alpine:3.19

RUN apk add --no-cache nginx git

# Add a changing line to force fresh clone every build
ARG CACHE_BUST=1
RUN echo "Build ID: ${CACHE_BUST}-$(date +%s)" && \
    git clone --depth 1 https://github.com/kevinarismendy/modpack-santi.git /tmp/repo && \
    find /tmp/repo -type f \( -name "*.toml" -o -name "*.bat" -o -name "*.sh" -o -name "*.ps1" -o -name "*.md" -o -name "*.txt" -o -name "*.conf" \) -exec sed -i 's/\r$//' {} \; && \
    mkdir -p /www/mods && \
    cp /tmp/repo/pack.toml /tmp/repo/index.toml /tmp/repo/packwiz-installer-bootstrap.jar /www/ && \
    cp -r /tmp/repo/mods/* /www/mods/ && \
    rm -rf /etc/nginx/http.d/default.conf && \
    rm -rf /tmp/repo

RUN cat > /etc/nginx/http.d/default.conf <<'EOF'
server {
    listen 80;
    server_name _;
    root /www;
    autoindex off;

    location ~* \.(toml|json)$ {
        add_header Cache-Control "no-cache, no-store, must-revalidate";
        add_header Pragma "no-cache";
        add_header Expires "0";
    }

    location ~* \.jar$ {
        add_header Cache-Control "public, max-age=3600";
    }

    location / {
        try_files $uri =404;
    }
}
EOF

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

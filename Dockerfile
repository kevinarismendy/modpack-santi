FROM alpine:3.19

RUN apk add --no-cache nginx git

# Clone the repo directly (works around Coolify's empty build context)
RUN git clone --depth 1 https://github.com/kevinarismendy/modpack-santi.git /tmp/repo && \
    mkdir -p /www/mods && \
    cp /tmp/repo/pack.toml /tmp/repo/index.toml /tmp/repo/packwiz-installer-bootstrap.jar /www/ && \
    cp -r /tmp/repo/mods/* /www/mods/ && \
    rm -rf /etc/nginx/http.d/default.conf && \
    rm -rf /tmp/repo

COPY nginx.conf /etc/nginx/http.d/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

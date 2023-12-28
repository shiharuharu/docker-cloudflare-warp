mkdir -p /docker/cloudflare-warp/config

cat > /docker/cloudflare-warp/docker-compose.yaml <<EOF
version: '3.7'
services:
  cloudflare-warp:
    image: shiharuharu/cloudflare-warp:latest
    container_name: cloudflare-warp
    restart: unless-stopped
    privileged: true
    environment:
      - FAMILIES_MODE=off
      - CUSTOM_ENDPOINT=162.159.192.173:3854
    volumes:
      - ./config:/var/lib/cloudflare-warp
    ports:
      - 40000:1080
EOF

cat > /docker/cloudflare-warp/start-compose.sh <<EOF
#!/bin/bash
docker-compose -f /docker/cloudflare-warp/docker-compose.yaml kill
docker-compose -f /docker/cloudflare-warp/docker-compose.yaml down
docker-compose -f /docker/cloudflare-warp/docker-compose.yaml up -d
EOF
chmod +x /docker/cloudflare-warp/start-compose.sh

cat > /docker/cloudflare-warp/stop-compose.sh <<EOF
#!/bin/bash
docker-compose -f /docker/cloudflare-warp/docker-compose.yaml kill
docker-compose -f /docker/cloudflare-warp/docker-compose.yaml down
EOF
chmod +x /docker/cloudflare-warp/stop-compose.sh

/docker/cloudflare-warp/start-compose.sh
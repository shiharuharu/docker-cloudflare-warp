#!/bin/bash
set -m
warp-svc &
sleep 2

if [[ -n $TEAMS_ENROLL_TOKEN ]]; then
  warp-cli --accept-tos teams-enroll-token "${TEAMS_ENROLL_TOKEN}"
else
  warp-cli --accept-tos register
fi

warp-cli --accept-tos set-mode proxy
warp-cli --accept-tos disable-dns-log
warp-cli --accept-tos set-families-mode "${FAMILIES_MODE}"

if [[ $WARP_LISTEN_PORT ]]; then
  warp-cli --accept-tos set-proxy-port $WARP_LISTEN_PORT
else
  warp-cli --accept-tos set-proxy-port 40000
fi


if [[ -n $CUSTOM_ENDPOINT ]]; then
  warp-cli --accept-tos set-custom-endpoint "${CUSTOM_ENDPOINT}"
fi

if [[ -n $WARP_LICENSE ]]; then
  warp-cli --accept-tos set-license "${WARP_LICENSE}"
fi

warp-cli --accept-tos connect

if [[ -n $SOCKS5_PORT ]]; then
  socat tcp-listen:"${SOCKS5_PORT}",reuseaddr,fork tcp:localhost:40000 &
else
  socat tcp-listen:1080,reuseaddr,fork tcp:localhost:40000 &
fi
fg %1

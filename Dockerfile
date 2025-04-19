FROM golang:1.24-alpine AS derper

RUN go install tailscale.com/cmd/derper@latest

FROM tailscale/tailscale:stable

ENV DERP_IP=""

EXPOSE 80/tcp 443/tcp 3478/udp

COPY --from=derper /go/bin/derper /usr/local/bin/derper

RUN apk add --no-cache openssl && \
        mkdir -p /tailscale/derper-certs

CMD ["sh", "-c", "openssl req -new -newkey rsa:4096 -days 3650 -nodes -x509 \
        -subj \"/CN=${DERP_IP}\" \
        -addext \"subjectAltName=IP:${DERP_IP}\" \
        -keyout /tailscale/derper-certs/${DERP_IP}.key \
        -out /tailscale/derper-certs/${DERP_IP}.crt && \
        derper --hostname=${DERP_IP} --certmode=manual --certdir=/tailscale/derper-certs --verify-clients"]
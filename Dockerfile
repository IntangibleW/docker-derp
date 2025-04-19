FROM golang:1.24-alpine

ENV DERP_IP=

VOLUME /etc/derper/certs
VOLUME /var/run/tailscale/

EXPOSE 80/tcp 443/tcp 3478/udp

RUN go install tailscale.com/cmd/derper@latest

CMD ["sh", "-c", "derper --hostname=${DERP_IP} --certmode=manual --certdir=/etc/derper/certs --verify-clients"]
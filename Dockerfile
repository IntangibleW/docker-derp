FROM golang:alpine AS builder

RUN go install tailscale.com/cmd/derper@latest
RUN go install tailscale.com/cmd/derpprobe@latest

FROM alpine

WORKDIR /app

COPY --from=builder /go/bin/* /usr/local/bin/

CMD derper

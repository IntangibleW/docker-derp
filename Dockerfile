FROM --platform=$BUILDPLATFORM golang:alpine AS builder

ARG TARGETOS
ARG TARGETARCH

ENV CGO_ENABLED=0
ENV GOOS=${TARGETOS}
ENV GOARCH=${TARGETARCH}

RUN go install tailscale.com/cmd/derper@latest
RUN go install tailscale.com/cmd/derpprobe@latest

FROM alpine

WORKDIR /app

COPY --from=builder /go/bin/derper /usr/local/bin/
COPY --from=builder /go/bin/derpprobe /usr/local/bin/

CMD derper

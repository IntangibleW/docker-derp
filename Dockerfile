FROM --platform=$BUILDPLATFORM golang:alpine AS builder

ARG TARGETOS
ARG TARGETARCH

ENV CGO_ENABLED=0
ENV GOOS=${TARGETOS}
ENV GOARCH=${TARGETARCH}

RUN go install tailscale.com/cmd/derper@latest tailscale.com/cmd/derpprobe@latest && \
    if [ -d "${GOPATH}/bin/${GOOS}_${GOARCH}" ]; then \
      cp "${GOPATH}/bin/${GOOS}_${GOARCH}/derper" "${GOPATH}/bin/derper"; \
      cp "${GOPATH}/bin/${GOOS}_${GOARCH}/derpprobe" "${GOPATH}/bin/derpprobe"; \
    fi

FROM alpine

WORKDIR /app

COPY --from=builder /go/bin/derper /usr/local/bin/
COPY --from=builder /go/bin/derpprobe /usr/local/bin/

CMD ["derper"]

FROM golang:latest-alpine
RUN go install tailscale.com/cmd/derper@latest

ARG HOSTNAME
ENV HOSTNAME $HOSTNAME

CMD ["derper", "--hostname=${HOSTNAME}"]

# stage1 builds rolebot STATICALLY in a fatter development environment
FROM golang:latest AS build

LABEL maintainer="duck. <me@duck.moe>"

WORKDIR /go/src/github.com/luaduck/rolebot

ADD . /go/src/github.com/luaduck/rolebot

RUN go get && CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

# stage2 moves the static binary into a super ultra lean image
FROM alpine:latest

RUN apk add --no-cache ca-certificates

WORKDIR /app

COPY --from=build /go/src/github.com/luaduck/rolebot/main .

EXPOSE 53

CMD ["/app/main"]
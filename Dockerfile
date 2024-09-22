FROM golang:alpine AS build
COPY httpenv.go /go
RUN go build httpenv.go

FROM alpine
# Install curl
RUN apk --no-cache add curl \
    && addgroup -g 1000 httpenv \
    && adduser -u 1000 -G httpenv -D httpenv
COPY --from=build --chown=httpenv:httpenv /go/httpenv /httpenv
EXPOSE 8888
CMD ["/httpenv"]
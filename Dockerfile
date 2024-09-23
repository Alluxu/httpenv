# First stage: build the Go application
FROM golang:alpine AS build
WORKDIR /app
COPY httpenv.go /app
RUN go build -o /app/httpenv httpenv.go

# Test stage (this is the missing stage)
FROM alpine AS test
RUN apk add --no-cache curl
COPY --from=build /app/httpenv /httpenv

# You can run any tests you need here, or just build the image
CMD ["/httpenv"]

# Final stage: production image
FROM alpine
RUN addgroup -g 1000 httpenv \
    && adduser -u 1000 -G httpenv -D httpenv \
    && apk add --no-cache curl

COPY --from=build --chown=httpenv:httpenv /app/httpenv /httpenv

WORKDIR /app

EXPOSE 8888

# Start the application when the container starts
CMD ["/httpenv"]
# First stage: build the application
FROM golang:alpine AS build
WORKDIR /app
COPY httpenv.go /app

# Build the binary
RUN go build -o /app/httpenv httpenv.go

# Confirm the binary is built
RUN ls -la /app/httpenv

# Second stage: production image
FROM alpine
RUN addgroup -g 1000 httpenv \
    && adduser -u 1000 -G httpenv -D httpenv

# Copy the binary from the build stage
COPY --from=build /app/httpenv /httpenv

# Confirm the binary is copied
RUN ls -la /httpenv

LABEL org.opencontainers.image.source=https://github.com/alluxu/httpenv
EXPOSE 8888
CMD ["/httpenv"]
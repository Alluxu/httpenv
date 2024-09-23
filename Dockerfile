# First stage: build the application
FROM golang:alpine AS build
WORKDIR /app
COPY httpenv.go /app
RUN go build -o /app/httpenv httpenv.go

# Final stage: production image
FROM alpine
RUN addgroup -g 1000 httpenv \
    && adduser -u 1000 -G httpenv -D httpenv \
    && apk add --no-cache curl  # Ensure curl is installed for health checks

# Copy the built binary from the build stage
COPY --from=build --chown=httpenv:httpenv /app/httpenv /httpenv

# Ensure the correct working directory
WORKDIR /app

# Expose the port the application listens on
EXPOSE 8888

# Start the application when the container starts
CMD ["/httpenv"]
# First stage: build the application
FROM golang:alpine AS build
WORKDIR /app
COPY httpenv.go /app

# Ensure the go binary is correctly built
RUN go build -o httpenv httpenv.go

# Verify if the binary is built correctly
RUN ls -la /app/httpenv

# Second stage: test
FROM build AS test
COPY . /app
RUN go test ./...

# Final stage: production image
FROM alpine
RUN addgroup -g 1000 httpenv \
    && adduser -u 1000 -G httpenv -D httpenv

# Copy binary from build stage
COPY --from=build /app/httpenv /httpenv

# Verify if the binary is successfully copied
RUN ls -la /httpenv

LABEL org.opencontainers.image.source=https://github.com/alluxu/httpenv
EXPOSE 8888
CMD ["/httpenv"]
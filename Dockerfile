# First stage: build the application
FROM golang:alpine AS build
WORKDIR /app
COPY httpenv.go /app
RUN go build -o /app/httpenv httpenv.go

# Verify if the binary is correctly built
RUN ls -la /app/httpenv

# Final stage: production image
FROM alpine
RUN addgroup -g 1000 httpenv \
    && adduser -u 1000 -G httpenv -D httpenv
COPY --from=build --chown=httpenv:httpenv /app/httpenv /httpenv

# Verify if the binary is successfully copied
RUN ls -la /httpenv

LABEL org.opencontainers.image.source=https://github.com/alluxu/httpenv
EXPOSE 8888
CMD ["/httpenv"]
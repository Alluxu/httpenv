# First stage: build the application
FROM golang:alpine AS build
COPY httpenv.go /go
RUN go build -o /app/httpenv httpenv.go

# Second stage: test
FROM build AS test
RUN go test ./... # Add test logic here if necessary

# Final stage: production image
FROM alpine
RUN addgroup -g 1000 httpenv \
    && adduser -u 1000 -G httpenv -D httpenv
COPY --from=build --chown=httpenv:httpenv /app/httpenv /httpenv
EXPOSE 8888
CMD ["/httpenv"]
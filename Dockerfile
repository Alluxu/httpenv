# First stage: build the application
FROM golang:alpine AS build
WORKDIR /app
COPY httpenv.go /app
COPY go.mod /app  # Ensure that you copy go.mod if it exists
RUN go mod tidy    # This command downloads the dependencies
RUN go build -o /app/httpenv httpenv.go

# Second stage: test
FROM build AS test
COPY . /app        # Copy the entire project for testing
RUN go test ./...

# Final stage: production image
FROM alpine
RUN addgroup -g 1000 httpenv \
    && adduser -u 1000 -G httpenv -D httpenv
COPY --from=build --chown=httpenv:httpenv /app/httpenv /httpenv
EXPOSE 8888
CMD ["/httpenv"]
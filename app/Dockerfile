FROM golang:1.24.0 AS builder

WORKDIR /app

COPY go.mod .
COPY go.sum .
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o main 

# Use a minimal base image
FROM alpine:latest
WORKDIR /app
COPY --from=builder /app /app/
EXPOSE 3000
CMD ["./main"]

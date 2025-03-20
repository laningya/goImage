FROM golang:1.23-alpine AS builder
WORKDIR /app

RUN apk add --no-cache git

RUN git clone https://github.com/laningya/goImage.git .

RUN go mod tidy
RUN go build -o myApp ./cmd/server/main.go

FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/myApp .
COPY --from=builder /app/static /app/static
COPY --from=builder /app/templates /app/templates
COPY --from=builder /app/images /app/images
COPY --from=builder /app/config.json /app/config.json

CMD ["./myApp"]

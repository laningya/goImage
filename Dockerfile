# 1. 拉取代码并构建阶段
FROM golang:1.23-alpine AS builder
WORKDIR /app

# 使用 git clone 拉取代码
RUN apk add --no-cache git

# 克隆指定的 GitHub 仓库
RUN git clone https://github.com/laningya/goImage.git .

# 安装依赖和构建
RUN go mod tidy
RUN go build -o myApp ./cmd/server/main.go

# 2. 运行阶段（精简镜像）
FROM alpine:latest
WORKDIR /root/
COPY --from=builder /app/myApp .
COPY --from=builder /app/static .
COPY --from=builder /app/templates .
COPY --from=builder /app/images .
COPY --from=builder /app/config.json .

# 运行命令
CMD ["./myApp"]

#!/bin/bash

# 设置变量
DOCKER_IMAGE="my-nginx"
DOCKER_CONTAINER="my-nginx-container"
NGINX_LOG_DIR="/data/nginx/logs"
NGINX_HTML_DIR="/data/nginx/html"

# 确保目录存在
mkdir -p ${NGINX_LOG_DIR}
mkdir -p ${NGINX_HTML_DIR}

# 构建新镜像
echo "开始构建 Docker 镜像..."
docker build -t ${DOCKER_IMAGE}:latest .

# 停止并删除旧容器
echo "停止旧容器..."
docker stop ${DOCKER_CONTAINER} || true
docker rm ${DOCKER_CONTAINER} || true

# 启动新容器
echo "启动新容器..."
docker run -d --name ${DOCKER_CONTAINER} \
  -p 80:80 \
  -v ${NGINX_LOG_DIR}:/var/log/nginx \
  -v ${NGINX_HTML_DIR}:/usr/share/nginx/html \
  --restart=always \
  ${DOCKER_IMAGE}:latest

# 检查容器是否正常运行
echo "检查容器状态..."
if [ "$(docker ps -q -f name=${DOCKER_CONTAINER})" ]; then
  echo "部署成功！"
else
  echo "部署失败！"
  exit 1
fi

# 清理不用的镜像
echo "清理旧镜像..."
docker image prune -f

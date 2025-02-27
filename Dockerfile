# 使用官方 nginx 镜像作为基础镜像
FROM nginx

# 暴露端口
EXPOSE 80 443

COPY test.html /usr/share/nginx/html/test.html

# CMD [ "pwd" ]
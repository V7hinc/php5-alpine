FROM alpine:3.6

RUN cp /etc/apk/repositories /etc/apk/repositories.old && \
    echo 'https://mirrors.aliyun.com/alpine/v3.6/main/' >/etc/apk/repositories && \
    echo 'https://mirrors.aliyun.com/alpine/v3.6/community/' >>/etc/apk/repositories

RUN apk add --no-cache --update-cache tzdata runit nginx php5-fpm php5-common \
    php5-curl php5-gd php5-gettext php5-iconv php5-intl php5-json php5-mcrypt php5-xml php5-xmlreader php5-zlib && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' >/etc/timezone

ADD rootfs /

RUN sed -i -e 's/user\s*=\s*nobody/user = nginx/g' \
           -e 's/group\s*=\s*nobody/group = nginx/g' /etc/php5/php-fpm.conf && \
    find /etc/service -type f -name 'run' -exec chmod +x {} \; && \
    mkdir -p /run/nginx

VOLUME ["/var/lib/nginx/html"]

EXPOSE 80 443

CMD ["runsvdir", "/etc/service"]


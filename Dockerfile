FROM daocloud.io/library/alpine:3.6

RUN cp /etc/apk/repositories /etc/apk/repositories.old && \
    echo 'https://mirrors.aliyun.com/alpine/v3.6/main/' >/etc/apk/repositories && \
    echo 'https://mirrors.aliyun.com/alpine/v3.6/community/' >>/etc/apk/repositories

RUN apk add --no-cache --update-cache tzdata runit nginx php5-fpm php5-common \
    php5-curl php5-gd php5-gettext php5-iconv php5-intl php5-json php5-mcrypt php5-xml php5-xmlreader php5-zlib && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' >/etc/timezone

RUN mkdir -p /run/nginx /etc/service/nginx /etc/service/php5-fpm

COPY nginx.service /etc/service/nginx/run

COPY php5-fpm.service /etc/service/php5-fpm/run

COPY default.conf /etc/nginx/conf.d/default.conf

RUN sed -i -e 's/user\s*=\s*nobody/user = nginx/g' /etc/php5/php-fpm.conf && \
    sed -i -e 's/group\s*=\s*nobody/group = nginx/g' /etc/php5/php-fpm.conf

VOLUME ["/var/lib/nginx/html"]

EXPOSE 80

CMD ["runsvdir", "/etc/service"]


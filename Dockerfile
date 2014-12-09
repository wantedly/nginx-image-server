FROM quay.io/wantedly/buildpack-deps:14.04

ENV NGINX_VERSION 1.6.2
ENV NGX_SMALL_LIGHT_VERSION 0.6.3

RUN apt-get update && \
    apt-get install -y libpcre3 libpcre3-dev libssl-dev && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/src/nginx && \
    curl -SL http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz \
    | tar xzC /usr/src/nginx --strip-components=1

RUN mkdir -p /usr/src/ngx_small_light && \
    curl -SL https://github.com/cubicdaiya/ngx_small_light/archive/v$NGX_SMALL_LIGHT_VERSION.tar.gz \
    | tar xzC /usr/src/ngx_small_light --strip-components=1 && \
    cd /usr/src/ngx_small_light && \
    ./setup && \
    cd /usr/src/nginx && \
    ./configure \
      --prefix=/opt/nginx \
      --conf-path=/etc/nginx/nginx.conf \
      --sbin-path=/opt/nginx/sbin/nginx \
      --with-http_stub_status_module \
      --with-pcre \
      --add-module=/usr/src/ngx_small_light && \
    make && \
    make install && \
    rm -rf /usr/src/ngx_small_light && \
    rm -rf /usr/src/nginx

RUN mkdir -p /var/www/nginx-default && \
    mkdir /var/www/nginx-default/images && \
    mkdir /var/www/nginx-default/cache && \
    mkdir /var/www/nginx-default/tmp && \
    mkdir -p /var/log/nginx

RUN touch /var/www/nginx-default/index.html
COPY files/favicon.ico /var/www/nginx-default/favicon.ico
COPY files/authorized_ip /etc/nginx/authorized_ip
COPY files/cache_path /etc/nginx/cache_path
COPY files/nginx.conf /etc/nginx/nginx.conf
COPY files/image-server.conf /etc/nginx/conf.d/image-server.conf

CMD ["/opt/nginx/sbin/nginx"]

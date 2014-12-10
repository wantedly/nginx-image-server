FROM quay.io/wantedly/buildpack-deps:14.04
MAINTAINER Seigo Uchida <spesnova@gmail.com> (@spesnova)

ENV NGINX_VERSION 1.6.2

RUN mkdir -p /etc/nginx && \
    mkdir -p /var/log/nginx && \
    mkdir -p /var/run && \
    mkdir -p /etc/nginx/sites-available && \
    mkdir -p /etc/nginx/sites-enabled && \
    mkdir -p /etc/nginx/conf.d
    mkdir -p /var/www/nginx-default

RUN apt-get update && \
    apt-get install -y \
      binutils-doc \
      bison \
      flex \
      gettext \
      libpcre3 \
      libpcre3-dev \
      libssl-dev && \
    rm -rf /var/lib/apt/lists/*

COPY files/nginx.conf /etc/nginx/nginx.conf
COPY files/mime.types /etc/nginx/mime.types
COPY files/default.conf /etc/nginx/conf.d/default.conf
COPY files/index.html /var/www/nginx-default/index.html

ADD http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz /tmp/nginx-${NGINX_VERSION}.tar.gz
RUN cd /tmp && tar zxf nginx-${NGINX_VERSION}.tar.gz
RUN cd /tmp/nginx-${NGINX_VERSION} && \
    ./configure \
      --prefix=/opt/nginx \
      --conf-path=/etc/nginx/nginx.conf \
      --sbin-path=/opt/nginx/sbin/nginx \
      --with-http_stub_status_module \
      --with-pcre && \
    make && \
    make install

CMD ["/opt/nginx/sbin/nginx"]

FROM quay.io/wantedly/buildpack-deps:14.04
MAINTAINER Seigo Uchida <spesnova@gmail.com> (@spesnova)

ENV NGINX_VERSION 1.6.2
ENV NGX_SMALL_LIGHT_VERSION 0.6.3

# Install dependency packages
RUN apt-get update && \
    apt-get install -y \
      binutils-doc \
      bison \
      flex \
      gettext \
      libpcre3 \
      libpcre3-dev \
      libssl-dev \
      libperl-dev && \
    rm -rf /var/lib/apt/lists/*

# Build ImageMagick with WebP support
RUN mkdir -p /tmp/imagemagick && \
    cd /tmp/imagemagick && \
    apt-get update && \
    apt-get build-dep -y imagemagick && \
    apt-get install -y libwebp-dev devscripts && \
    apt-get source -y imagemagick && \
    cd imagemagick-* && \
    debuild -uc -us && \
    dpkg -i ../*magick*.deb && \
    rm -rf /tmp/imagemagick && \
    rm -rf /var/lib/apt/lists/*

# Fetch and unarchive nginx source
ADD http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz /tmp/nginx-${NGINX_VERSION}.tar.gz
RUN cd /tmp && tar zxf nginx-${NGINX_VERSION}.tar.gz

# Fetch and unarchive ngx_small_light module
ADD https://github.com/cubicdaiya/ngx_small_light/archive/v${NGX_SMALL_LIGHT_VERSION}.tar.gz /tmp/ngx_small_light-${NGX_SMALL_LIGHT_VERSION}.tar.gz
RUN cd /tmp && \
    tar zxf ngx_small_light-${NGX_SMALL_LIGHT_VERSION}.tar.gz && \
    cd /tmp/ngx_small_light-${NGX_SMALL_LIGHT_VERSION} && \
    ./setup

# Compile nginx
RUN cd /tmp/nginx-${NGINX_VERSION} && \
    ./configure \
      --prefix=/opt/nginx \
      --conf-path=/etc/nginx/nginx.conf \
      --sbin-path=/opt/nginx/sbin/nginx \
      --with-http_stub_status_module \
      --with-http_perl_module \
      --with-pcre \
      --add-module=/tmp/ngx_small_light-${NGX_SMALL_LIGHT_VERSION} && \
    make && \
    make install && \
    rm -rf /tmp/*

RUN mkdir -p /etc/nginx && \
    mkdir -p /var/run && \
    mkdir -p /etc/nginx/conf.d && \
    mkdir -p /var/www/nginx/{images,cache,tmp}

# Add config files
COPY files/nginx.conf /etc/nginx/nginx.conf
COPY files/mime.types /etc/nginx/mime.types

# Add contents
COPY files/favicon.ico /var/www/nginx/favicon.ico

EXPOSE 80 8090

CMD ["/opt/nginx/sbin/nginx"]

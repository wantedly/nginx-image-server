FROM ubuntu:14.04

ENV NGINX_VERSION 1.10.0
ENV NGX_SMALL_LIGHT_VERSION 0.8.0
ENV IMAGEMAGICK_VERSION 6.8.6-8

# Install dependency packages
RUN apt-get update && \
    apt-get install -y \
      binutils-doc \
      bison \
      flex \
      g++ \
      gettext \
      libpcre3 \
      libpcre3-dev \
      libssl-dev \
      libperl-dev \
      make && \
    rm -rf /var/lib/apt/lists/*

# Build ImageMagick with WebP support
RUN mkdir -p /tmp/imagemagick && \
    cd /tmp/imagemagick && \
    apt-get update && \
    apt-get build-dep -y imagemagick && \
    apt-get install -y libwebp-dev devscripts checkinstall && \
    curl -L https://launchpad.net/imagemagick/main/${IMAGEMAGICK_VERSION}/+download/ImageMagick-${IMAGEMAGICK_VERSION}.tar.gz > \
      ImageMagick-${IMAGEMAGICK_VERSION}.tar.gz && \
    tar zxf ImageMagick-${IMAGEMAGICK_VERSION}.tar.gz && \
    cd ImageMagick-${IMAGEMAGICK_VERSION} && \
    ./configure \
      --prefix=/usr \
      --sysconfdir=/etc \
      --libdir=/usr/lib/x86_64-linux-gnu \
      --enable-shared \
      --with-modules \
      --disable-openmp \
      --with-webp=yes \
      LDFLAGS=-L/usr/local/lib \
      CPPFLAGS=-I/usr/local/include && \
    make && \
    checkinstall -y && \
    rm -rf /tmp/imagemagick && \
    rm -rf /var/lib/apt/lists/*

# Fetch and unarchive nginx source
RUN curl -L http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz > /tmp/nginx-${NGINX_VERSION}.tar.gz && \
    cd /tmp && \
    tar zxf nginx-${NGINX_VERSION}.tar.gz

# Fetch and unarchive ngx_small_light module
RUN curl -L https://github.com/cubicdaiya/ngx_small_light/archive/v${NGX_SMALL_LIGHT_VERSION}.tar.gz > /tmp/ngx_small_light-${NGX_SMALL_LIGHT_VERSION}.tar.gz && \
    cd /tmp && \
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
    mkdir -p /opt/nginx/perl/lib && \
    mkdir -p /var/run && \
    mkdir -p /etc/nginx/conf.d && \
    mkdir -p /var/www/nginx/cache && \
    mkdir -p /var/www/nginx/images && \
    mkdir -p /var/www/nginx/tmp

# Add config files
COPY files/nginx.conf   /etc/nginx/nginx.conf
COPY files/mime.types   /etc/nginx/mime.types
COPY files/validator.pm /opt/nginx/perl/lib/validator.pm

EXPOSE 80 8090

CMD ["/opt/nginx/sbin/nginx"]

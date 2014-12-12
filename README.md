# Nginx Image Server
Docker Image for [Nginx](http://nginx.org/) image processing server(resize, crop, format) with [ngx_small_light](https://github.com/cubicdaiya/ngx_small_light).

## SUPPORTED TAGS

* `latest`
 * Nginx 1.6.2
 * ngx_small_light 0.6.3

## HOT TO USE
Trying this image quickly:

```bash
$ docker pull quay.io/wantedly/nginx-image-server
$ docker run \
    -d \
    --name nginx-image-server \
    -p 80:80 \
    -p 8090:8090 \
    -e "SERVER_NAME=image.example.com" \
    quay.io/wantedly/nginx-image-server
```

### Using your own configuration
You can build new docker image includes your own `nginx.conf`:

```
FROM quay.io/wantedly/nginx-image-server
COPY nginx.conf /etc/nginx/nginx.conf
```

Then, build with `docker build -t your-nginx-image-server .` and run:

```bash
$ docker run \
    -d \
    --name your-nginx-image-server \
    -p 80:80 \
    -p 8090:8090 \
    -e "SERVER_NAME=image.example.com" \
    your-nginx-image-server
```

### Recommended configurations
There are some recommended configurations to run Nginx in Docker Container.

* `daemon off;`

Run Nginx in the foreground to prevent your container will stop immediately after starting.

* `access_log /dev/stdout;`
* `error_log /dev/stdout info;`

Log to STDOUT to and send your logs to an external storage like S3 via fluentd or a service like PaperTrail.
This practice is followoing "Treat logs as event streams" in [12factor apps](http://12factor.net/logs).
It helps your container to be disposable.

* `env S3_HOST;` and `perl_set $s3_host_from_env 'sub { return $ENV{"S3_HOST"}; }';`

If you have to set secret key or some config different between development and production, use environment variables.
This practice is following "Store config in the environment" in [12factor apps](http://12factor.net/config).

You can see example configuration for these in `nginx.conf` under `example-files/` in this repo.

## LICENSE
[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE)

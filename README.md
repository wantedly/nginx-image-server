# Nginx Image Server [![Docker Repository on Quay.io](https://quay.io/repository/wantedly/nginx-image-server/status "Docker Repository on Quay.io")](https://quay.io/repository/wantedly/nginx-image-server)
Docker Image for [Nginx](http://nginx.org/) image processing server with [ngx_small_light](https://github.com/cubicdaiya/ngx_small_light).  
Image server can resize/crop/formatting (`png`, `webp`...etc) for images in local or AWS S3.

Please see https://github.com/cubicdaiya/ngx_small_light for more information about image processing.

## SUPPORTED TAGS

* `latest`
 * Nginx 1.6.2
 * ngx_small_light 0.6.3
 * ImageMagick 6.7.7-10 2014-12-11 Q16 with WebP support

## HOT TO USE

```bash
# Getting the image
$ docker pull quay.io/wantedly/nginx-image-server

# Fetch example image to try image-processing local image
$ curl -L https://raw.githubusercontent.com/wantedly/nginx-image-server/master/files/example.jpg > \
    /tmp/example.jpg

# Start the image server
$ docker run \
    --rm \
    -it \
    --name nginx-image-server \
    -p 80:80 \
    -p 8090:8090 \
    -v /tmp/example.jpg:/var/www/nginx/images/example.jpg \
    -e "SERVER_NAME=image.example.com" \
    -e "S3_HOST=<YOUR-BUCKET-NAME>.s3.amazonaws.com" \
    quay.io/wantedly/nginx-image-server
```

Then you can try image-processing via

* **Images in S3**: `http://<YOUR-SERVER.com>/small_light(dh=400,da=l,ds=s)/<PATH-TO-IMAGE-IN-S3>`
* **Images in Local**: `http://<YOUR-SERVER.com>/local/small_light(dh=400,da=l,ds=s)/images/example.jpg`

And `http://<YOUR-SERVER.com>:8090/status` retruns the nginx status.

### Custom configuration
You can build a docker image includes your own `nginx.conf`:

```
FROM quay.io/wantedly/nginx-image-server
COPY nginx.conf /etc/nginx/nginx.conf
```

Then build with `docker build -t your-nginx-image-server .` and run:

```bash
$ docker run \
    -d \
    --name your-nginx-image-server \
    -p 80:80 \
    your-nginx-image-server
```

Be sure to include `daemon off;` in your custom configuration to run Nginx in the foreground.
Otherwise your container will stop immediately after starting.

## TEST (experimentally)
### Feature(behavior) test
We're trying behavior test for this image using [infrataster](https://github.com/ryotarai/infrataster).  
Test files are under `test/feature` directory. You can run this test with follwing script:

```bash
$ script/cibuild
```

### Performance test
We're trying performance test for this image using [locust](http://locust.io/).  
Test files are under `test/performance` directory. You can run locust with follwing script:

```bash
# Run target container
$ script/run_target

# Export target IP
$ export TARGET_IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' target)

# Run locust as WebTool
$ script/run_locust -f locustfile.py -H http://${TARGET_IP}

# Run locust as CLI
$ script/run_locust -f locustfile.py -H http://${TARGET_IP} --no-web -c 5 -r 1 -n 10
```

## LICENSE
[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE)

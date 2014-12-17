FROM python:2.7.8
MAINTAINER Seigo Uchida <spesnova@gmail.com> (@spesnova)

RUN pip install locustio pyzmq
RUN mkdir /test
WORKDIR /test
CMD ["locust"]

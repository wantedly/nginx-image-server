FROM quay.io/wantedly/ruby:2.1.5
MAINTAINER Seigo Uchida <spesnova@gmail.com> (@spesnova)

ADD . /test
WORKDIR /test
RUN bundle install -j4

CMD ["bundle", "exec", "rspec", "-c"]

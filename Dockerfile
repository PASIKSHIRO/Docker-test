FROM ruby:2.6.3

MAINTAINER Yuriy Pasichynskiy <yuriy.pasichynskiy@teamvoy.com>

ENV APP_HOME /app
ENV BUNDLER_VERSION 2.1.4

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

ENV GEM_HOME=/bundle
ENV BUNDLE_JOBS=4
ENV BUNDLE_RETRY=3
ENV BUNDLE_PATH $GEM_HOME
ENV BUNDLE_BIN=/bundle/bin
ENV BUNDLE_APP_CONFIG=$BUNDLE_PATH

COPY Gemfile Gemfile.lock ./ 

RUN gem update --system && gem install bundler:$BUNDLER_VERSION
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
COPY . ./

RUN bundle check || bundle install

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

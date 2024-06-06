ARG RUBY_VERSION=${RUBY_VERSION:-2.7}
FROM ruby:${RUBY_VERSION}-alpine

RUN apk --update add --no-cache build-base bash && \
  apk add git && \
  apk add --no-cache libxml2 && \
  apk add --no-cache libxml2-dev && \
  apk add --no-cache sqlite-dev

ENV APP_HOME /usr/src/app/
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

COPY zuora.gemspec \
     Gemfile \
     $APP_HOME

RUN bundle config set --local system 'true' && \
  bundle install --no-cache && \
  bundle binstubs --all

COPY . $APP_HOME

CMD ["./container_loop.sh"]

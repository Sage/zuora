FROM ruby:2.7-alpine

RUN apk --update add --no-cache build-base bash && \
  apk add git && \
  apk add --no-cache libxml2 && \
  apk add --no-cache libxml2-dev && \
  apk add --no-cache sqlite-dev

ARG BUNDLE_SAGEONEGEMS__JFROG__IO

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

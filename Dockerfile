ARG RUBY_VERSION=${RUBY_VERSION:-2.7}
FROM ruby:${RUBY_VERSION}-alpine

RUN apk --update add --no-cache build-base bash && \
  apk add git && \
  apk add --no-cache libffi-dev && \
  apk add --no-cache libxml2 && \
  apk add --no-cache libxml2-dev && \
  apk add --no-cache sqlite-dev

RUN gem update --system 3.3.22 --no-document && \
  gem install bundler --no-document

ENV APP_HOME /usr/src/app/
RUN mkdir -p $APP_HOME
RUN mkdir $APP_HOMElib/zuora/
WORKDIR $APP_HOME

COPY /lib/zuora/version.rb $APP_HOME/lib/zuora/

COPY zuora.gemspec \
     Gemfile \
     $APP_HOME

RUN bundle config set --local system 'true' && \
  bundle install --no-cache && \
  bundle binstubs --all

COPY . $APP_HOME

CMD ["./container_loop.sh"]

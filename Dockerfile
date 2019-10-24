FROM ruby:2.6.3-alpine3.9

WORKDIR /app

RUN echo "http://mirrors.aliyun.com/alpine/v3.9/main/" | tee /etc/apk/repositories

RUN gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/ \
    && bundle config mirror.https://rubygems.org https://gems.ruby-china.com

COPY Gemfile Gemfile.lock ./

RUN apk update \
  && apk upgrade \
  && apk add --no-cache bash bash-doc bash-completion build-base tzdata libstdc++ \
  && gem install bundler \
  && bundle install --deployment --without development:test:doc \
  && rm -rf /var/cache/apk/*

COPY ./ ./

# CMD ["bundle", "exec", "rails", "c", "-e", "production"]
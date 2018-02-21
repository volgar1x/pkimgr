FROM ruby:2.5-alpine

COPY . /app
WORKDIR /app
ENV RAILS_ENV=production PORT=3000

RUN apk add --update gcc g++ make postgresql-dev nodejs yarn tzdata; \
    bundle install --deployment --without development test; \
    apk del gcc g++ make nodejs yarn

CMD bundle exec rails server -e $RAILS_ENV -p $PORT

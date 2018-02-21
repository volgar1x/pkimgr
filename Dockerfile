FROM ruby:2.5-alpine

COPY . /app
WORKDIR /app
ENV RAILS_ENV=development PORT=3000

RUN apk add --update gcc g++ make postgresql-dev nodejs tzdata && \
    bundle install --without test && \
    apk del gcc g++ make

CMD bundle exec rails db:migrate && \
    bundle exec rails db:seed && \
    bundle exec rails server -e $RAILS_ENV -p $PORT -b 0.0.0.0

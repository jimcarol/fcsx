FROM ruby:2.5

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

ENV DB_HOST $DB_HOST
ENV LANG=C.UTF-8
EXPOSE 80

CMD rackup -o 0.0.0.0 -p 80
FROM ruby:2.5

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

ENV DB_HOST $DB_HOST

CMD ["rackup", "-p", "3000"]
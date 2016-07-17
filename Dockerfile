FROM ruby:2.1

EXPOSE 4567

ADD . /code
WORKDIR /code

RUN bundle install

CMD bundle exec ruby app.rb
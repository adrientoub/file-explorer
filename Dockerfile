FROM ruby:2.6.3-alpine3.9

ENV RAILS_ENV=production
RUN apk add --no-cache git ruby-dev build-base libxml2-dev libxslt-dev libffi-dev tzdata nodejs
RUN git clone https://github.com/adrientoub/file-explorer /file-explorer
WORKDIR /file-explorer
RUN bundle install --deployment --without development --without test
RUN bundle exec rails assets:precompile
RUN apk del git ruby-dev build-base libxml2-dev libxslt-dev libffi-dev nodejs
RUN rm -rf /file-explorer/tmp /file-explorer/vendor/**/*.o
EXPOSE 3000
ENTRYPOINT ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]

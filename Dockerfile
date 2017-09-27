FROM ubuntu:16.04

RUN apt-get update && apt-get install -y --no-install-recommends git ca-certificates libssl-dev curl wget bzip2 gcc g++ make libreadline-dev npm && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN cd /root && git clone https://github.com/rbenv/rbenv.git ~/.rbenv && \
    git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
ENV PATH /root/.rbenv/plugins/ruby-build/bin:/root/.rbenv/bin:$PATH

RUN rbenv install 2.4.0
RUN rbenv global 2.4.0
ENV PATH /root/.rbenv/shims:$PATH
RUN ruby -v
RUN gem install bundler
RUN mkdir /file-explorer
RUN git clone https://github.com/adrientoub/file-explorer
WORKDIR /file-explorer
RUN bundle install --deployment --without development --without test
ENV RAILS_ENV=production
RUN bundle exec rails assets:precompile
EXPOSE 3000

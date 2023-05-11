FROM ruby:3.2.2

RUN curl -sL https://deb.nodesource.com/setup_lts.x | bash -
RUN apt-get update -qq && \
    apt-get upgrade -y && \
    apt-get -y install nodejs git-core default-mysql-client wkhtmltopdf sqlite3 build-essential \
    libssl-dev libreadline-dev libyaml-dev libsqlite3-dev libffi-dev \
    libxml2-dev libxslt1-dev zlib1g-dev libcurl4-openssl-dev software-properties-common

RUN gem update --system && \
    gem install bundler && \
    gem install rails && \
    bundler -v

WORKDIR /ProjectForTerraform
COPY . .

ARG rails_env
ENV RAILS_ENV ${rails_env}
ARG pusher_url
ENV PUSHER_URL ${pusher_url}
ENV RAILS_SERVE_STATIC_FILES 'true'
ENV BUNDLER_VERSION 2.4.12
RUN bundle install
RUN #npm install
RUN bundle exec rake assets:precompile
RUN cp config/database.yml.docker config/database.yml

EXPOSE 3000

#RUN #bundle exec newrelic deployment

# Start the main process.
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
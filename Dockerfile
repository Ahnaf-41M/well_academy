ARG RUBY_VERSION=3.3.6
FROM ruby:${RUBY_VERSION}-slim

RUN apt-get update -qq && \
    apt-get install -y \
    build-essential \
    libpq-dev \
    libyaml-dev \
    nodejs \
    postgresql-client \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copies the entire current directory into the container’s working directory (/docker_api_app).
COPY . .

RUN gem install bundler && bundle install

# Declares that the container will listen on port 3005.
# This doesn’t publish the port, but is useful for documentation and when used with Docker Compose.
EXPOSE 3005

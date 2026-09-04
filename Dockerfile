ARG RUBY_VERSION=4.0.6
# Digest pins ruby:4.0.6-slim, which is Debian trixie — same distro the 3.4.10
# pin resolved to. `bundle install` below reruns whenever COPY . . changes
# (Gemfile.lock included), so no Ruby-version cache key is needed here.
FROM ruby:${RUBY_VERSION}-slim@sha256:58479f164d5947f852da27a4436c89bb986a811f959c40552bc7f6ccaabcc9c9

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

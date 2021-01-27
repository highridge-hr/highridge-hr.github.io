ARG JEKYLL_VERSION=3.8
ARG BASEDIR=docs
FROM jekyll/jekyll:${JEKYLL_VERSION}

COPY docs/Gemfile /opt/setup/
COPY docs/Gemfile.lock /opt/setup/

RUN bundle install --clean --gemfile=/opt/setup/Gemfile
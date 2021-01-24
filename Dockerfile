ARG JEKYLL_VERSION=3.8
ARG BASEDIR=docs
FROM jekyll/jekyll:${JEKYLL_VERSION}

COPY Gemfile /opt/setup/
COPY Gemfile.lock /opt/setup/

RUN bundle install --gemfile=/opt/setup/Gemfile
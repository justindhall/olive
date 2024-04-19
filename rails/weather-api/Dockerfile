FROM public.ecr.aws/docker/library/ruby:3.2.2-alpine3.18
MAINTAINER justindhall

RUN apk add --update --no-cache \
      build-base \
      gcompat \
      tzdata \
      git \
      libxml2-dev \
      libxslt-dev \
      libpq-dev \
      postgresql13-client \
      less

RUN adduser -D app-user
RUN mkdir /app && chown -R app-user /app
ENV BUNDLE_PATH=/home/app-user/.gems
WORKDIR /app
USER app-user

COPY --chown=app-user:app-user

RUN bundle config build.nokogiri --use-system-libraries
COPY --chown=app-user:app-user Gemfile Gemfile.lock ./
RUN bundle install

COPY --chown=app-user:app-user  . ./
EXPOSE 3000
CMD /bin/sh

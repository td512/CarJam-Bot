FROM ruby:2.7-alpine
COPY entrypoint.sh /entrypoint.sh
RUN mkdir /app && chmod 755 /entrypoint.sh
ADD . /app
ENTRYPOINT /entrypoint.sh


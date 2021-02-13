FROM ruby:2.7.2
MAINTAINER Karthikishorejs@gmail.com

RUN apt-get update 

# Define where our application will live inside the image
RUN mkdir -p /var/app
WORKDIR /var/app
COPY . .

# Prevent bundler warnings
RUN gem install bundler -v 2.2.7
RUN bundle install

# Add a script to be executed every time the container starts.
EXPOSE 3000
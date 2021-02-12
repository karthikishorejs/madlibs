FROM phusion/passenger-ruby27
MAINTAINER Karthikishorejs@gmail.com
ENV HOME /root
ENV RAILS_ENV production
CMD ["/sbin/my_init"]


RUN rm -f /etc/service/nginx/down
RUN rm /etc/nginx/sites-enabled/default
ADD nginx.conf /etc/nginx/sites-enabled/madlib_website.conf

ADD . /home/app/madlib_website
WORKDIR /home/app/madlib_website
RUN chown -R app:app /home/app/madlib_website
RUN sudo -u app bundle install --deployment

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 80
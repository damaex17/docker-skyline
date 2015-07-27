FROM phusion/baseimage:0.9.15
MAINTAINER Maximilian Weber <maximilian.weber@gmail.com>

#RUN echo deb http://archive.ubuntu.com/ubuntu $(lsb_release -cs) main universe > /etc/apt/sources.list.d/universe.list
RUN apt-get -y update\
 && apt-get -y upgrade

# dependencies
RUN apt-get -y --force-yes install vim\
 nginx\
 python-dev\
 python-flup\
 python-pip\
 expect\
 git\
 memcached\
 sqlite3\
 libcairo2\
 libcairo2-dev\
 python-cairo\
 pkg-config\
 nodejs\
 python-numpy\
 python-scipy\
 python-pandas\
 python-patsy\
 python-statsmodels\
 python-msgpack\
 redis-server
 

# python dependencies
RUN pip install django==1.3\
 python-memcached==1.53\
 django-tagging==0.3.1\
 twisted==11.1.0\
 txAMQP==0.6.2

# install graphite
RUN git clone -b 0.9.12 https://github.com/graphite-project/graphite-web.git /usr/local/src/graphite-web
WORKDIR /usr/local/src/graphite-web
RUN python ./setup.py install
ADD scripts/local_settings.py /opt/graphite/webapp/graphite/local_settings.py
ADD conf/graphite/ /opt/graphite/conf/

# install whisper
RUN git clone -b 0.9.12 https://github.com/graphite-project/whisper.git /usr/local/src/whisper
WORKDIR /usr/local/src/whisper
RUN python ./setup.py install

# install carbon
RUN git clone -b 0.9.12 https://github.com/graphite-project/carbon.git /usr/local/src/carbon
WORKDIR /usr/local/src/carbon
RUN python ./setup.py install

# install skyline 
RUN git clone https://github.com/etsy/skyline /usr/local/src/skyline
WORKDIR /usr/local/src/skyline
RUN pip install -r ./requirements.txt


# install statsd
RUN git clone -b v0.7.2 https://github.com/etsy/statsd.git /opt/statsd
ADD conf/statsd/config.js /opt/statsd/config.js

# config nginx
RUN rm /etc/nginx/sites-enabled/default
ADD conf/nginx/nginx.conf /etc/nginx/nginx.conf
ADD conf/nginx/graphite.conf /etc/nginx/sites-available/graphite.conf
RUN ln -s /etc/nginx/sites-available/graphite.conf /etc/nginx/sites-enabled/graphite.conf

# config redis
RUN mkdir -p /var/dump
RUN mkdir -p /var/run/redis
ADD conf/redis.conf /etc/redis/redis.conf

# init django admin
ADD scripts/django_admin_init.exp /usr/local/bin/django_admin_init.exp
RUN /usr/local/bin/django_admin_init.exp

# config skyline
ADD conf/skyline/settings.py /usr/local/src/skyline/src/settings.py
RUN mkdir -p /var/run/skyline /var/log/skyline

# logging support
RUN mkdir -p /var/log/carbon /var/log/graphite /var/log/nginx
ADD conf/logrotate /etc/logrotate.d/graphite
RUN chmod 644 /etc/logrotate.d/graphite

# daemons
ADD daemons/carbon.sh /etc/service/carbon/run
ADD daemons/carbon-relay.sh /etc/service/carbon-relay/run
ADD daemons/carbon-aggregator.sh /etc/service/carbon-aggregator/run
ADD daemons/graphite.sh /etc/service/graphite/run
ADD daemons/statsd.sh /etc/service/statsd/run
ADD daemons/nginx.sh /etc/service/nginx/run
ADD daemons/redis.sh /etc/service/redis/run
ADD daemons/skyline-analyzer.sh /etc/service/analyzer/run
ADD daemons/skyline-horizon.sh /etc/service/horizon/run
ADD daemons/skyline-webapp.sh /etc/service/webapp/run
ADD daemons/skyline.sh	/etc/service/skyline/run

# cleanup
RUN apt-get clean\
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# defaults
EXPOSE 80:80 1500:1500 2003:2003 2013:2013 2024:2024 8125:8125/udp
VOLUME ["/opt/graphite", "/etc/nginx", "/opt/statsd", "/etc/logrotate.d", "/var/log"]
ENV HOME /root
CMD ["/sbin/my_init"]

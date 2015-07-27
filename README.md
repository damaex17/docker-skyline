# Anomaly Detection #
# with: docker - graphite - statsd - skyline

### setup ###

* install docker.io
* clone repository
* go to repository
* build image `docker build -t docker-graphite-statsd-skyline`
* run container `docker run -p 80:80 -p 1500:1500 -p 2013:2013 -p 2003:2003 -p 8125:8125 -p 6379:6379 docker-graphite-statsd-skyline`

### how does it work? ###


![graphite_skyline.png](https://bitbucket.org/repo/MLxrza/images/3128802284-graphite_skyline.png)



* send your datapoints to port 2013 (carbon-relay)
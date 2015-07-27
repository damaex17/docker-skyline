# Docker Image for Skyline

## Get Anomaly Detection for time series up and running in minutes

### Includes the following components

* [Nginx](http://nginx.org/) - reverse proxies the graphite dashboard
* [Graphite](http://graphite.readthedocs.org/en/latest/) - front-end dashboard
* [Carbon](http://graphite.readthedocs.org/en/latest/carbon-daemons.html) - back-end
* [Statsd](https://github.com/etsy/statsd/wiki) - UDP based back-end proxy
* [Skyline](https://github.com/etsy/skyline) - etsy/skyline "It'll detect your anomalies! Part of the Kale stack." - discontinued!

### Image

Built using [Phusion's base image](https://github.com/phusion/baseimage-docker) and [hopsoft/docker-graphite-statsd](https://github.com/hopsoft/docker-graphite-statsd)

* All related processes are run as daemons & monitored with [runit](http://smarden.org/runit/).
* Includes additional services such as logrotate & redis

### setup ###

* install docker.io
* clone repository
* cd to repository
* build image `docker build -t docker-skyline .`
* run container `docker run -p 80:80 -p 1500:1500 -p 2003:2003 -p 8125:8125 docker-skyline`

### Mapped Ports

| Host | Container | Service |
| ---- | --------- | ------- |
|   80 |        80 | nginx   |
| 1500 |      1500 | skyline-web|
| 2003 |      2003 | carbon-cache  |
| 8125 |      8125 | statsd  |

### using it ###

* send data in graphite format to port 2003 (relay) or 8125 (statsd)
* open graphite dashboard in a browser at [http://localhost/dashboard](http://localhost/dashboard)
* open skyline app in a browser at [http://localhost:1500](http://localhost:1500)

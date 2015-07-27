#!/bin/bash

/usr/bin/python /opt/graphite/bin/carbon-relay.py start --debug 2>&1 >> /var/log/carbon.log

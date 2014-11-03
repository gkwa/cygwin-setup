#!/bin/sh

# remove syslogd
cygrunsrv --stop syslogd
cygrunsrv --remove syslogd

# replace with syslog-ng
/usr/bin/syslog-ng-config --yes

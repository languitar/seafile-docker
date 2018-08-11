#!/bin/bash

/scripts/symlinks.sh

exec /usr/bin/supervisord -c /etc/supervisord.conf

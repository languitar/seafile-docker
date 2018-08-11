#!/bin/bash

/scripts/symlinks.sh
. /scripts/seafile-env.sh

script="$1"
shift

set -e

# stop server
[ -f /var/run/supervisord.pid ] && supervisorctl stop all

cd /opt/seafile/latest
eval "$script" "$@"

# starting server
[ -f /var/run/supervisord.pid ] && supervisorctl start all

echo "Done"

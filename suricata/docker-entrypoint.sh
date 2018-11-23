#! /bin/bash

# If the first command does not look like argument, assume its a
# command the user wants to run. Normally I wouldn't do this.
if [ "${1:0:1}" != "-" ]; then
    PS1=${PS1} exec "$@"
fi

exec LD_PRELOAD="/usr/lib/libtcmalloc_minimal.so.0" suricata -c /etc/suricata/suricata.yaml -i $INTERFACE_NAME $@
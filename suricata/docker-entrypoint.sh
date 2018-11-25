#! /bin/bash

# If the first command does not look like argument, assume its a
# command the user wants to run. Normally I wouldn't do this.
if [ "${1:0:1}" != "-" ]; then
    PS1=${PS1} exec "$@"
fi
 LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libtcmalloc_minimal.so.4"
exec suricata -c /etc/suricata/suricata.yaml -i $INTERFACE_NAME $@
#!/usr/bin/with-contenv bash

PUID=${PUID:0}
PGID=${PGID:0}

chown -R $PUID:$PGID /app

s6-setuidgid $PUID:$PGID /app/bin/adchppd -c /app/config

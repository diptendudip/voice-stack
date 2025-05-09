#!/bin/sh
# 1) launch FreeSWITCH in the background
freeswitch -nonat -nc -c &
# 2) wait 5 s for FreeSWITCH to finish booting
sleep 5
# 3) run the Node orchestrator
node /app/index.js

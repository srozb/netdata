#!/bin/bash

docker run -d --cap-add SYS_PTRACE \
           --net=host \
           -v /proc:/host/proc:ro \
           -v /sys:/host/sys:ro \
           --name net-data \
           srozb/net-data


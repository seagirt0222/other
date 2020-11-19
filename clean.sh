#!/bin/bash
#keep 10days

sudo journalctl --vacuum-time=10

sudo truncate -s 0 /var/lib/docker/*/*/*-json.log

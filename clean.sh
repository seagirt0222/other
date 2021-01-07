#!/bin/bash
#keep 10days

sudo journalctl --vacuum-time=10

sudo rm *.gz

sudo rm *.1

sudo truncate -s 0 /var/lib/docker/*/*/*-json.log

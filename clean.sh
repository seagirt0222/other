#!/bin/bash
#keep 10days
# 保留10天
sudo journalctl --vacuum-time=10

# del log
sudo rm *.gz

# del log
sudo rm *.1

# del log
sudo truncate -s 0 /var/lib/docker/*/*/*-json.log

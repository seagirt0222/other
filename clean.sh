#!/bin/bash
# del log
sudo truncate -s 0 /var/lib/docker/*/*/*-json.log

function myclean {
    ## Show free space
    df -Th | grep -v fs
    # Will need English output for processing
    LANG=en_GB.UTF-8

    ## Clean apt cache
    apt-get update
    apt-get -f install
    apt-get -y autoremove
    apt-get clean

    ## Remove old versions of snap packages
    # CLOSE ALL SNAPS BEFORE RUNNING THIS
    set -eu
    snap list --all | awk '/disabled/{print $1, $3}' |
        while read snapname revision; do
            snap remove "$snapname" --revision="$revision"
        done

    ## Remove old versions of Linux Kernel
    dpkg -l 'linux-*' | sed '/^ii/!d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'/d;s/^[^ ]* [^ ]* \([^ ]*\).*/\1/;/[0-9]/!d' | xargs apt-get -y purge

    ## Rotate and delete old logs
    /etc/cron.daily/logrotate
    find /var/log -type f -iname *.gz -delete
    sudo journalctl --rotate
    sudo journalctl --vacuum-time=1s

    ## Show free space
    df -Th | grep -v fs
}

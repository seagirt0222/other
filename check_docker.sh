#!/bin/bash

sudo timedatectl set-timezone Asia/Taipei
#check install 
if [ -d "/var/lib/docker" ]; then
    # 目錄 /path/to/dir 存在
    echo "Docker is already installed."
else
    # 目錄 /path/to/dir 不存在
   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
   sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
   sudo apt-get update
   
   sudo apt-get install docker-ce -y 
   echo "Docker is install  success."
   sleep 5
   
   sudo apt-get install docker-compose -y
   echo "Docker is install success."
   sleep 5
fi


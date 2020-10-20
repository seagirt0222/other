#!/bin/bash

sudo timedatectl set-timezone Asia/Taipei
#docker install
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) \
stable"
sudo apt-get update
sudo apt-get install docker-ce -y 
sleep 10

#sudo docker info | grep "Docker Root Dir"
#sleep 10 

service docker stop
sleep 3

mv /var/lib/docker /data2/docker
sleep 3

ln -s /data2/docker /var/lib/docker
sleep 3

sudo cat <<EOF > /etc/default/docker
OPTIONS=--graph="/data2/docker" -H fd://                 
EOF

service docker start

sudo docker info | grep "Docker Root Dir"
sleep 3
echo "Change Docker Path Sussus" && exit 0

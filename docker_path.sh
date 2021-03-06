#!/bin/bash

if [ -d "/var/lib/docker" ]; then
            # 目錄 /path/to/dir 存在
    echo "Docker is Already Installed."

else
 # 目錄 /path/to/dir 不存在
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
    
    sudo apt-get update
    sudo apt-get install docker-ce -y
    echo "Docker Install  Success."
    sleep 5

    sudo apt-get install docker-compose -y
    echo "Docker-comopse Install Success."
    sleep 5
fi

sudo docker info | grep "Docker Root Dir"

service docker stop
sleep 3

read -p "Input Change Folder Path"  folder_ID
echo  -e "Change Folder Path to "${folder_ID}" " 

mv /var/lib/docker ${folder_ID}
sleep 3

ln -s ${folder_ID} /var/lib/docker
sleep 3

sudo cat <<EOF > /etc/default/docker
OPTIONS=--graph="${folder_ID}" -H fd://                 
EOF

service docker start

sudo docker info | grep "Docker Root Dir"
sleep 3
echo "Change Docker Path Sussus" && exit 0


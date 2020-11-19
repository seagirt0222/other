#!/bin/bash
echo "1.git kafka+elk，2.git grafana，3.git tick，4.install telegraf，5.install filebeat，6.docker&compose，7.change docker folder，8.sudo docker " 
echo -n "Chiose："
read ANS

case $ANS in
  1) git clone https://github.com/seagirt0222/kafka-docker
     git clone https://github.com/deviantony/docker-elk
    echo "Git clone Kafka+Elk OK";;

  2) git clone https://github.com/seagirt0222/grafana
    echo "Git clone Grafana OK ";;

  3) git clone https://github.com/seagirt0222/tick
    echo "Git clone Tick OK";;
    
  4) wget -qO- https://repos.influxdata.com/influxdb.key | sudo apt-key add -
source /etc/lsb-release
echo "deb https://repos.influxdata.com/${DISTRIB_ID,,} ${DISTRIB_CODENAME} stable" | sudo tee /etc/apt/sources.list.d/influxdb.list
sleep 3
 
 sudo apt-get update && sudo apt-get install telegraf
 sudo systemctl start telegraf
 
 echo "install telegraf OK";;
    
  5) wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
sleep 3
sudo apt-get install apt-transport-https
sudo apt update
sudo apt install filebeat
    echo "install filebeat OK";;
    
  6) sudo timedatectl set-timezone Asia/Taipei
    #check install 
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

     echo "Install Docker-compose OK";;
    
  7) sudo docker info | grep "Docker Root Dir"

service docker stop
sleep 3

read -p "Input Change Folder Path :"  folder_ID
echo  -e "Change Folder Path To :"${folder_ID}" " 

mv /var/lib/docker ${folder_ID}
sleep 3

ln -s ${folder_ID} /var/lib/docker
sleep 3

sudo cat <<EOF > /etc/default/docker
OPTIONS=--graph="/data2/docker" -H fd://                 
EOF

service docker start

sudo docker info | grep "Docker Root Dir"
sleep 3
echo "Change Docker Path Sussus & Please restart the device " && exit 0  ;;
    
   8) #sudo groupadd docker
sudo gpasswd -a ${USER} docker
sudo service docker restart
newgrp - docker
    echo "docker don't use sudo OK ";;
    
  *)
   echo "只能按1,2,3,4,5,6,7,8的按鍵";;
esac

#!/bin/bash
echo "1.git kafka+elk，2.git grafana，3.git tick，4.git zabbix，5.telegraf，6.filebeat，7.docker&compose，8.change docker folder，9.install SSL，0.docker no sudo " 
echo -n "Chiose："
read ANS

case $ANS in
# git kafka
  1) git clone https://github.com/seagirt0222/kafka-docker
     git clone https://github.com/seagirt0222/docker-elk
    echo "Clone Kafka+Elk OK";;
    
# git grafana
  2) git clone https://github.com/seagirt0222/grafana
    echo "GClone Grafana OK ";;

# git tick
  3) git clone https://github.com/seagirt0222/tick
    echo "Clone Tick OK";;
    
# git zabbix
  4) git clone https://github.com/seagirt0222/zabbix
    echo "Clone Zabbix OK";;
   
#sudo groupadd docker
#sudo gpasswd -a ${USER} docker
#sudo service docker restart
#newgrp - docker
#echo "docker don't use sudo OK ";;
    
#  install telegraf   
  5) wget -qO- https://repos.influxdata.com/influxdb.key | sudo apt-key add -
source /etc/lsb-release
echo "deb https://repos.influxdata.com/${DISTRIB_ID,,} ${DISTRIB_CODENAME} stable" | sudo tee /etc/apt/sources.list.d/influxdb.list
sleep 2
 
sudo apt-get update && sudo apt-get install telegraf
sudo systemctl start telegraf
 
echo "install telegraf";;

# install filebeat
  6) wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
sleep 3
sudo apt-get install apt-transport-https
sudo apt update
sudo apt install filebeat
    echo "install filebeat";;
    
# install docker & docker-compose     
  7) sudo timedatectl set-timezone Asia/Taipei
  
sudo apt-get update 
#check install 
if [ -d "/var/lib/docker" ]; then
# 目錄 /path/to/dir 存在
echo "Docker is Already Installed."
else
# 目錄 /path/to/dir 不存在
#curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
#sudo add-apt-repository \
#"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
#$(lsb_release -cs) \
#stable"

# Add Docker's official GPG key:
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  
sudo apt-get update

#sudo apt-get install docker-ce -y
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
echo "Docker Install  Success" && exit 0;;
sleep 2

sudo apt-get install docker-compose -y
echo "Docker-comopse Install Success" && exit 0;;
sleep 2
fi

echo "Install Docker-compose OK";;
    
# change docker folder     
  8) sudo docker info | grep "Docker Root Dir"
service docker stop
sleep 2

read -p "Input Change Folder Path :"  folder_ID
echo  -e "Change Folder Path To :"${folder_ID}" " 

mv /var/lib/docker ${folder_ID}
sleep 2

ln -s ${folder_ID} /var/lib/docker
sleep 2

#sudo cat <<EOF > /etc/default/docker
#OPTIONS=--graph="/data/docker" -H fd://                 
#EOF

service docker start

sudo docker info | grep "Docker Root Dir"
sleep 3
echo "Change Docker Path Sussus & Please restart the device " && exit 0;;
 

#install SSL 
   ８) sudo apt-get update
sudo apt-get install software-properties-common -y
sudo add-apt-repository universe
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sleep 2 
sudo apt-get install certbot python3-certbot-nginx -y
sudo certbot --nginx
echo "Letsencrypt SSL install OK";;
  *)
  
  
# docker no use sudo  
     0) sudo apt-get update
     
sudo groupadd docker

sudo gpasswd -a ${USER} docker

sudo service docker restart

newgrp - docker

echo "Docker sudo Success" && exit 0  ;;

sleep 2

# install zabbix- agent2
     11) sudo apt-get update
     
sudo wget https://repo.zabbix.com/zabbix/5.4/debian/pool/main/z/zabbix-release/zabbix-release_5.4-1+debian11_all.deb

sudo dpkg -i zabbix-release_5.4-1+debian11_all.deb

sudo apt-get update

sudo install zabbix-agent2

sudo systemctl start zabbix-agent2.service

sudo systemctl enable zabbix-agent2.service

sudo systemctl status zabbix-agent2.service

echo "zabbix-agent2 install Success" && exit 0  ;;

sleep 2
     
   echo "input number key[1 , 2 , 3 , 4 , 5 , 6 , 7 , 8 , 9 , 0 , 11 ]";;
esac

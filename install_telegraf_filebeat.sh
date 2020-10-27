#/bin/sh
echo "1.install Telegraf，2.install Filebeat"
echo -n "Chiose："
read ANS

case $ANS in
  1) wget -qO- https://repos.influxdata.com/influxdb.key | sudo apt-key add -
     source /etc/lsb-release
     echo "deb https://repos.influxdata.com/${DISTRIB_ID,,} ${DISTRIB_CODENAME} stable" | sudo tee /etc/apt/sources.list.d/influxdb.list
     
     sudo apt-get update
     sleep 5
     sudo apt-get -y install telegraf
     sleep 5
     echo "Install telegraf OK";;
     
  2) wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
     echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
     sleep 5
     
     sudo apt-get install apt-transport-https
     sudo apt update
     sleep 5
     sudo apt install filebeat
     sleep 5
     
     echo "Install Filebeat OK";;
      *)
   echo "目前只有2個選項,只能按1,2,的按鍵";;

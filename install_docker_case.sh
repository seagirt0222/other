#!/bin/bash
echo "1.git kafka+elk，2.git grafana，3.git tick，4.install docker，5.install docker-compose"
echo -n "Chiose："
read ANS

case $ANS in
  1) git clone https://github.com/seagirt0222/kafka-docker
    echo "git clone Kafka+Elk OK";;

  2) git clone https://github.com/seagirt0222/grafana
    echo "git clone Grafana OK ";;

  3) git clone https://github.com/seagirt0222/tick
    echo "git clone Tick OK";;

  4) sudo timedatectl set-timezone Asia/Taipei
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

     echo "install docker-compose OK";;

  5) sudo apt-get install docker-compose -y
    echo "install docker-compose OK";;
  *)
   echo "只能按1,2,3,4,5的按鍵";;
esac

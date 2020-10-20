#!/bin/bash

# This bash script is referenced by https://www.hostinger.com/tutorials/how-to-install-docker-on-ubuntu

echo 'Check your Linux Distribution....'

which lsb_release > /dev/null 2>&1

if [[ $? != 0 ]]; then
    echo 'This Linux distribution is not supported by this bash script...'
    echo 'Stopped it.'
    exit 1;
fi;

echo 'Check user is root or normal user....'
sudo_prefix=''

if [[ $USER == 'root' ]]; then
    echo "It's root user..."
else
    echo "Check this ${USER} has sudo..."
    which sudo > /dev/null 2>&1
    if [[ $? != 0 ]]; then
        echo 'Please install sudo package.....'
        exit 1;
    fi;

    sudo_prefix='sudo '
fi;

echo "Let's start installing Docker......"

${sudo_prefix}apt-get update
${sudo_prefix}apt-get upgrade
${sudo_prefix}apt-get install curl apt-transport-https ca-certificates software-properties-common -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | ${sudo_prefix} apt-key add -
${sudo_prefix}add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

${sudo_prefix}apt-get update
${sudo_prefix}apt-get install docker-ce -y

${sudo_prefix}systemctl enable --now docker

echo "Check whether Docker service daemon is enabled/started currently..."

${sudo_prefix}systemctl status --no-pager docker > /dev/null 2>&1

if [[ $? != 0 ]]; then
    echo 'The Docker service daemon is not running correctly...'
    echo 'Stopped it.'
    exit 1;
fi;

echo 'The Docker service daemon is running currently. Done.'

if [[ ${whoami} != 'root' ]]; then
    read -p "Do you want to let ${whoami} user execute Docker without sudo [Y/n]? " result
    if [[ $result == 'Y' ]]; then
        ${sudo_prefix}gpasswd -a "${USER}" docker
    fi;
fi;

# References: https://medium.com/@bennyh/docker-and-proxy-88148a3f35f7

read -p "Do you want to set proxy [Y/n]? " proxy_answer_result
if [[ $proxy_answer_result == 'Y' ]]; then
    read -p "Please create proxy setting file: (Please set absoulte file path): " proxy_setting_path
    if [[ ! -f $proxy_setting_path ]]; then
        echo "$proxy_setting_path is not correct"
        exit 1;
    fi;
    
    echo "Check the proxy variables are set on host operating system...."
    env | grep "^http_proxy="
    if [[ $? != 0 ]]; then
        echo "http_proxy env variable is not set.... Try to set it."
        http_proxy=$(cat $proxy_setting_path | grep "^http_proxy=")
        echo "$http_proxy" | ${sudo_prefix}tee -a /etc/environment
    fi;
    
    env | grep "^https_proxy="
    if [[ $? != 0 ]]; then
        echo "https_proxy env variable is not set.... try to se it."
        https_proxy=$(cat $proxy_setting_path | grep "^https_proxy=")
        echo "$https_proxy" | ${sudo_prefix}tee -a /etc/environment
    fi;
    
    env | grep "^socks_proxy="
    if [[ $? != 0 ]]; then
        echo "socks_proxy env variable is not set....Try to set it."
        socks_proxy=$(cat $proxy_setting_path | grep "^socks_proxy=")
        echo "$socks_proxy" | ${sudo_prefix}tee -a /etc/environment
    fi;
    
    source /etc/environment
    
    echo "Override /etc/systemd/system/docker.service.d/http-proxy.conf file..."
    echo ""
    ${sudo_prefix}mkdir -p /etc/systemd/system/docker.service.d/
    ${sudo_prefix}touch /etc/systemd/system/docker.service.d/http-proxy.conf

    echo "[Service]" | ${sudo_prefix}tee -a /etc/systemd/system/docker.service.d/http-proxy.conf
    http_proxy=$(cat $proxy_setting_path | grep "^http_proxy" | awk '{split($1,a,"="); print a[2]}')
    https_proxy=$(cat $proxy_setting_path | grep "^http_proxy" | awk '{split($1,a,"="); print a[2]}')
    
    echo "Environment=\"HTTP_PROXY=${http_proxy}\"" | ${sudo_prefix}tee -a /etc/systemd/system/docker.service.d/http-proxy.conf
    echo "Environment=\"HTTP_PROXY=${https_proxy}\"" | ${sudo_prefix}tee -a /etc/systemd/system/docker.service.d/http-proxy.conf
    
    echo "Override ${HOME}/.docker/config.json..."
    
    echo "{" > ${HOME}/.docker/config.json
    echo " "proxies":" >> ${HOME}/.docker/config.json
    echo " {" >> ${HOME}/.docker/config.json
    echo "   "default":" >> ${HOME}/.docker/config.json
    echo "   {" >> ${HOME}/.docker/config.json
    echo "     \"httpProxy\": \"${http_proxy}\"," >> ${HOME}/.docker/config.json
    echo "     \"httpsProxy\": \"${https_proxy}\"" >> ${HOME}/.docker/config.json
    echo "   }" >> ${HOME}/.docker/config.json
    echo " }" >> ${HOME}/.docker/config.json
    echo "}" >> ${HOME}/.docker/config.json
    
    echo "Restart service......"
    
    ${sudo_prefix}systemctl restart docker
    
    echo "Now the Docker will support your customized proxy setting! Enjoy it!"
fi;

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




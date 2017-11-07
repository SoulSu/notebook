#!/bin/bash


# 安装 google-chrome
sudo wget https://repo.fdzh.org/chrome/google-chrome.list -P /etc/apt/sources.list.d/
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub  | sudo apt-key add -

# 移除一些不需要的包
sudo apt-get remove libreoffice-common  
sudo apt-get remove unity-webapps-common 
sudo apt-get remove thunderbird totem rhythmbox empathy brasero simple-scan gnome-mahjongg aisleriot 
sudo apt-get remove gnome-mines cheese transmission-common gnome-orca webbrowser-app gnome-sudoku  landscape-client-ui-install  
sudo apt-get remove onboard deja-dup 

#　添加主题
sudo add-apt-repository ppa:noobslab/themes
sudo add-apt-repository ppa:noobslab/icons
sudo add-apt-repository ppa:shutter/ppa

# 更新本地软件库
sudo apt-get update

# tweak tool
sudo apt-get install -y unity-tweak-tool
# install google-chrome
sudo apt-get install -y google-chrome-stable
# theam 
sudo apt-get install -y flatabulous-theme
# theam icon 
sudo apt-get install -y ultra-flat-icons

sudo apt-get install -y libnss2

sudo apt-get install -y zsh
sudo apt-get install -y mc
sudo apt-get install -y vim
sudo apt-get install -y git 
# jietux 一款很好用的截图软件
sudo apt-get install -y shutter
# docker
sudo apt-get install -y apt-transport-https ca-certificates
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

sudo echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" >> /etc/apt/sources.list.d/docker.list
sudo apt-get -y purge lxc-docker
sudo apt-cache policy docker-engine

# 安装　zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"


#!/bin/bash
# install.sh



echo -e "Console > Installing essential GPIO-Control libarys & packages °°°!"


export a="sudo apt-get install -y "
export g="sudo git clone "


sudo apt-get update;
sudo apt-get upgrade -y;
sudo apt-get dist-upgrade -y;
sudo apt autoremove -y;



function essential_base() {
    echo -e "Console > Installing base-packages!"
    $a make cmake build-essential sof*prop*c* gcc clang libc6* git curl wget 
    $a apt-*trans*https
    $a python3-dev python3-pip python3-venv
    $a swig


}


function join_grp() {
    echo -e "Console > Adding USER to functional-Group!"

    ls -l /home/
    read -p "user > " usr
    gpasswd -a $usr docker
    gpasswd -a $usr pi
    gpasswd -a $usr i2c
    gpasswd -a $usr spi
    gpasswd -a $usr gpio
    gpasswd -a $usr sudo
}


function clone() {
    echo -e "Console > Cloning Github-Repos!"
    mkdir ~/.tmp
    cd ~/.tmp

    $g https://github.com/BPI-SINOVOIP/RPi.GPIO
    $g https://github.com/BPI-SINOVOIP/BPI-WiringPi
    $g https://github.com/BPI-SINOVOIP/BPI-WiringPi2
    $g https://github.com/BPI-SINOVOIP/BPI-WiringPi2-Python
    me=$(whoami)
    sudo chmod 777 -R ../**
    sudo chown $me -hR ../**


    cd BPI-WiringPi
    sudo chmod a+x -R ../*
    chmod +x ./build
    sudo ./build
    sudo ldconfig -n /usr/local/lib
    sudo ldconfig
    cd wiringPi
    make static
    sudo make install-static

    cd ~/.tmp
    cd BPI-WiringPi2
    sudo chmod a+x -R ../*
    chmod +x ./build
    sudo ./build
    sudo ldconfig -n /usr/local/lib
    sudo ldconfig
    cd wiringPi
    make static
    sudo make install-static


    cd ~/.tmp
    cd BPI-WiringPi2-Python
    sudo chmod a+x -R ../*
    swig -python wiringpi.i
    sudo python setup.py build install
    sudo python test.py
    swig -python wiringpi.i
    sudo python3 setup.py build install
    sudo python3 test.py
    sudo python setup.py build install
    sudo python setup.py build install


    cd ~/.tmp
    cd RPi.GPIO
    sudo chmod a+x -R ../*
    sudo python3 create*.py
    sudo python3 setup.py install
    sudo pip3 install . --break-system-packages
    cd examples


}


function cmdloop() {
    while true;
    do

    read -p "Console > " cmd
    case $cmd in
        g) read -p "Git-Clone > " url && $g $url; continue;;
        i) read -p "APT-Install > " pkg && $a $pkg; continue;;
        u) sudo apt-get update; continue;;
        g) sudo apt-get upgrade -y; continue;;
        gu) sudo apt-get dist-uprgade -y; continue;;
        iall) essential_base && clone && join_grp; continue;;
        gpasswd) join_grp; continue;;
        clone) clone; continue;;
        q|Q) echo -e "Console > EXIT!" && break; exit;;
        *) $cmd; continue;;

    esac
    done
}

cmdloop;
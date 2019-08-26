#!/bin/bash
# Installs Wine 4.x and UORenaissance
# Variables
# See uor-wine.sh.conf
scriptname=`basename "$0"`
source $scriptname.conf


#Install Wine 4.x
dpkg --add-architecture i386
wget -qO - https://dl.winehq.org/wine-builds/winehq.key | sudo apt-key add -
apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main'

apt update && apt install --install-recommends winehq-stable -y
wine --version

#Add fixes for Wine
sudo apt install libcap2-bin 
sudo setcap cap_sys_ptrace=eip /usr/bin/wineserver
sudo setcap cap_sys_ptrace=eip /usr/bin/wine-preloader

# Install winetricks and helpers
sudo apt install cabextract unzip p7zip wget curl zenity kdialog
wget  https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
chmod +x winetricks
sudo cp winetricks /usr/local/bin
# install bash completion script
wget  https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks.bash-completion
sudo cp winetricks.bash-completion /usr/share/bash-completion/completions/winetricks

# Setup wine directory at $HOME/$uorwineprefix
$uorwineprefix wine wineboot
# Configure XP
$uorwineprefix winetricks winecfg
$uorwineprefix winetricks msxml3
$uorwineprefix winetricks vcrun2010
$uorwineprefix winetricks vcrun2013
$uorwineprefix winetricks gdiplus
$uorwineprefix bash winetricks dotnet452 corefonts
winetricks dotnet30



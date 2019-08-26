#!/bin/bash
# Installs Wine 4.x and UORenaissance
# Variables
# See uor-wine.sh.conf
scriptname=`basename "$0"`
source $scriptname.conf

#Show variables
echo UOR Wine directory is $HOME/$uordir
echo Wine Prefix  is $WINEPREFIX
echo Wine Architecture is $WINEARCH
echo Please wait while the script installs Wine and support packages.
echo This will take a few minutes
echo Track the install in another terminal setting with the following command
echo tail -f $scriptname.log

# Log output to $scriptname.log
exec &> $scriptname.log

#Show variables
echo UOR Wine directory is $HOME/$uordir
echo Wine Prefix  is $WINEPREFIX
echo Wine Architecture is $WINEARCH

#Create the UOR Wine Prefix Directory 
if [ ! -d "$HOME/$uordir" ]; then
	echo Create the UOR Wine Prefix Directory
	mkdir $HOME/$uordir
else
	#Use this just for testing to have a clean directory each time
	echo Removing UOR Wine Prefix Directory for testing	
	rm -rf $HOME/$uordir
	echo Create the UOR Wine Prefix Directory
	mkdir $HOME/$uordir
fi



#Install Wine 4.x
sudo dpkg --add-architecture i386
wget -qO - https://dl.winehq.org/wine-builds/winehq.key | sudo apt-key add -
sudo apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main'

sudo apt install --install-recommends winehq-stable -y
wine --version

#Add fixes for Wine
sudo apt install libcap2-bin 
sudo setcap cap_sys_ptrace=eip /usr/bin/wineserver
sudo setcap cap_sys_ptrace=eip /usr/bin/wine-preloader

# Install winetricks and helpers
sudo apt install cabextract unzip p7zip wget curl zenity kdialog -y
if [ -f winetricks ];then
	rm winetricks*
fi
wget  https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
chmod +x winetricks
sudo cp winetricks /usr/local/bin
# install bash completion script
wget  https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks.bash-completion
sudo cp winetricks.bash-completion /usr/share/bash-completion/completions/winetricks

# Setup wine directory at $HOME/$uorwineprefix
wine wineboot
#winetricks winecfg
winetricks -q win7
winetricks -q corefonts
winetricks -q msxml3
winetricks -q vcrun2010
winetricks -q vcrun2013
winetricks -q gdiplus
winetricks -q dotnet452
winetricks -q dotnet48
winetricks -q dotnet30

# Copy Directories to Wine instance if they exist
# Copy previous installs to the uor-wine script directory
# Copy the c:\Ultima Online directory to the "Ultima Online" directory
# Download UOR-Razor from http://www.uor-razor.com/ and unzip to "Razor" Directory
# Copy the "c:\Program Files x86\UOAM" directory to "UOAM" directory
if [ -d "Ultima Online" ];then
	cp -a "Ultima Online" "$HOME/$uordir/drive_c/"
fi

if [ -d "UOAM" ];then
	cp -a "UOAM" "$HOME/$uordir/drive_c/"
fi

if [ -d "Razor" ];then
	cp -a "Razor" "$HOME/$uordir/drive_c/"
fi

#!/bin/bash
# Installs Wine 4.x and UORenaissance
# Variables
# See uor-wine.sh.conf
scriptname=`basename "$0"`
source $scriptname.conf

#Show variables
echo UOR Wine directory is $uordir
echo Wine Prefix  is $WINEPREFIX
echo Wine Architecture is $WINEARCH
echo Wine Debug is $WINEDEBUG
echo Please wait while the script installs Wine and support packages.
echo This will take a few minutes
echo Track the install in another terminal setting with the following command
echo tail -f $scriptname.log

# Log output to $scriptname.log
exec &> $scriptname.log

#Show variables
echo UOR Wine directory is $uordir
echo Wine Prefix  is $WINEPREFIX
echo Wine Architecture is $WINEARCH
echo Wine Debug is $WINEDEBUG
echo Please wait while the script installs Wine and support packages.
echo This will take a few minutes
echo Track the install in another terminal setting with the following command

#Create the UOR Wine Prefix Directory 
if [ ! -d "$uordir" ]; then
	echo Create the UOR Wine Prefix Directory
	mkdir "$uordir"
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

# Setup wine directory at $uordir
wine wineboot
winetricks -q win7
winetricks -q corefonts
winetricks -q msxml3
winetricks -q vcrun2010
winetricks -q vcrun2013
winetricks -q gdiplus
winetricks -q dotnet452
winetricks -q dotnet48
winetricks -q dotnet30

# Create .desktop icon
uor_icon=$(cat <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=UO Renaissance
Comment=Runs Razor in Wine
Exec=$uordir/uor
Icon=$uordirUOLogo.png
Path=$uordir
Terminal=false
StartupNotify=false
EOF
)

echo -e "${uor_icon}" | tee "$uordir/UO Renaissance.desktop
	
# Copy Directories to Wine instance if they exist
# Copy previous installs to the uor-wine script directory
# Copy the c:\Ultima Online directory to the "Ultima Online" directory
# Download UOR-Razor from http://www.uor-razor.com/ and unzip to "Razor" Directory
# Copy the "c:\Program Files x86\UOAM" directory to "UOAM" directory
if [ -d "Ultima Online" ];then
	#cp -a "Ultima Online" "$uordir/drive_c/"
	ln -s "$uordir/Ultima Online" "$uordir/drive_c/Ultima Online"
fi

if [ -d "UOAM" ];then
	#cp -a "UOAM" "$HOME/$uordir/drive_c/"
	ln -s "$uordir/UOAM" $uordir/drive_c/UOAM"
fi

if [ -d "Razor" ];then
	cp -a "Razor" "$HOME/$uordir/drive_c/"
fi

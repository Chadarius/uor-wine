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
rm winetricks*

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
Icon=$uordir/UOLogo.png
Path=$uordir
Terminal=false
StartupNotify=false
EOF
)

echo -e "${uor_icon}" | tee "$uordir/UO Renaissance.desktop"
	
# Copy Directories to Wine instance if they exist
# Copy previous installs to the uor-wine script directory
# Copy the c:\Ultima Online directory to the "Ultima Online" directory
# Download UOR-Razor from http://www.uor-razor.com/ and unzip to "Razor" Directory
# Copy the "c:\Program Files x86\UOAM" directory to "UOAM" directory
# If you leave them blank the script will download and install Ultima Online from UORenaissance.
if [ -d "$uordir/Ultima Online" ];then
	cp -a "$uordir/Ultima Online" "$uordir/drive_c"	
else
	# Download UO Renaissance if it doesn't exist already
	if [ ! -f "$uodir/UO_Renaissance_Client_Full.exe" ];then
		wget "http://www.uorenaissance.com/downloads/UO_Renaissance_Client_Full.exe"
	fi
	# Install UO Renaissance
	if [ -f "$uodir/UO_Renaissance_Client_Full.exe" ];then
		uorwine "$uodir/UO_Renaissance_Client_Full.exe" -q  
fi

# Copy UOAM dir if exists otherwise move UOR Installed UOAM to root of drive_c
if [ -d "$uordir/UOAM" ];then
	cp -a "$uordir/UOAM" "$uordir/drive_c"
else
	if [ -d "$uodir/drive_c/Program Files/UOAM" ];then
		mv "$uodir/drive_c/Program Files/UOAM"
	fi
fi

# Copy Razor dir if exists otherwise download and unzip to drive_c
if [ -d "$uordir/Razor" ];then
	cp -a "$uordir/Razor" "$uordir/drive_c"
else
	# Download UOR Razor
	if [ ! -f "$uodir/Razor_UOR_CE-1.5.0.16.zip" ];then
		wget "http://www.uor-razor.com/Razor_UOR_CE-1.5.0.16.zip"
	fi
	# Unzip Razor to drive_c
	if [ -f "$uodir/Razor_UOR_CE-1.5.0.16.zip" ];then
		unzip Razor_UOR_CE-1.5.0.16.zip -d "$uordir/drive_c/Razor"
	fi	
fi

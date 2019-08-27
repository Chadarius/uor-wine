# uor-wine
Setup wine to play UO Renaissance

Download the repo

mkdir ~/workspace # Or wherever you want to put uor-wine scripts
git clone https://github.com/Chadarius/uor-wine.git

Run the following commands to setup Wine using the settings in uor-install.sh.conf
cd ~/workspace/uor-wine
./uor-install.sh

Be patient as it installs. It will take quite a few minutes

This will create a ~/uor wine folder. 

If you include a "Ultima Online", UOAM, and Razor folder in ~/workspace/uor-wine the script will copy each folder to the root of the wine drive_c folder.

You can download the UO Renaissance installer from http://www.uorenaissance.com/downloads/UO_Renaissance_Client_Full.exe

To install it run the following from the ~/workspace/uor-wine

./uorwine /path/to/UO_Renaissance_Client_Full.exe

You can also use winetricks with the following command from the ~/workspace/uor-wine directory

./uorwinetricks [commands here]

For instance to run taskmanager run the following

./uorwinetricks taskmgr





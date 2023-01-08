#!/bin/bash

rel=$(curl https://github.com/iredmail/iRedMail/tags -s | grep 'tool-tip for="toggle-commit-'| awk '{print substr($3, 20, 5) }')
iRMLATEST=$(echo $rel | awk '{print substr($1, 1) }')

echo "Updating and Installing dependencys"
sudo apt update && apt -y upgrade
sudo apt install -y dialog

echo "Installing iRedMail ${iRMLATEST} the most current version"
wget "https://github.com/iredmail/iRedMail/archive/refs/tags/${iRMLATEST}.tar.gz"
tar zxf ${iRMLATEST}.tar.gz
cd iRed*
sudo chmod +x iRedMail.sh
rm -rf ../${iRMLATEST}.tar.gz
./iRedmail.sh

echo "Take a note of your settings now"
sudo amavisd-new showkeys
read -p "Press [Enter] once you have copied this output..."

echo "Installing latest version of iRedMail Admin"
admrel=$(curl https://github.com/iredmail/iRedAdmin/tags -s | grep 'tool-tip for="toggle-commit-'| awk '{print substr($3, 20, 3) }')
iRMADM=$(echo $admrel | awk '{print substr($1, 1) }')
wget "https://github.com/iredmail/iRedAdmin/archive/refs/tags/${iRMADM}.tar.gz"
tar zxf ${iRMADM}.tar.gz
cd iRedAdmin*/tools
sudo chmod +x upgrade_iredadmin.sh
rm -rf ../${iRMADM}.tar.gz
./upgrade_iredadmin.sh

echo "Add DKIM Key to your DNS as a TXT Record"
sudo amavisd-new showkeys
read -p "Press [Enter] once you have copied this output..."

echo "Installing SSL certs and rebooting"
hostname=$(hostname -f)
sudo apt install -y certbot python3-certbot-nginx
sudo certbot --nginx -d ${hostname}
sudo mv /etc/ssl/certs/iRedMail.crt{,.bak}
sudo mv /etc/ssl/private/iRedMail.key{,.bak}
sudo ln -sf /etc/letsencrypt/live/mail.flonix.ml/fullchain.pem /etc/ssl/certs/iRedMail.crt
sudo ln -sf  /etc/letsencrypt/live/mail.flonix.ml/privkey.pem /etc/ssl/private/iRedMail.key
sudo reboot

#!/bin/bash

rel=$(curl https://github.com/iredmail/iRedMail/tags -s | grep 'tool-tip for="toggle-commit-'| awk '{print substr($3, 20, 5) }')
iRMLATEST=$(echo $rel | awk '{print substr($1, 1) }')
hostname=$(hostname -f)
domain=$(hostname -d)

echo "Updating and Installing dependencys"
sudo apt update && apt -y upgrade
sudo apt install -y dialog

echo "Installing iRedMail ${iRMLATEST} the most current version"
wget "https://github.com/iredmail/iRedMail/archive/refs/tags/${iRMLATEST}.tar.gz"
tar zxf ${iRMLATEST}.tar.gz
cd iRed*
sudo chmod +x iRedMail.sh
rm -rf ../${iRMLATEST}.tar.gz
./iRedMail.sh

echo "Your SPF Record should be set as"
echo "${hostname}.   3600    IN  TXT "v=spf1 mx -all""

echo "To Configure autodiscover add the following DNS Records"
echo "autodiscover.${domain}.   10          mx      ${hostname}."
echo "autoconfig.${domain}.   10          mx      ${hostname}."

echo "Your DKIM Key is"
sudo amavisd-new showkeys

echo "Please take a note of your settings now (you might need to scroll up)."
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

echo "Installing SSL certs and rebooting"
sudo apt install -y certbot python3-certbot-nginx
sudo certbot certonly --webroot --agree-tos --email info@${domain} -d ${hostname} -w /var/www/html/
sudo mv /etc/ssl/certs/iRedMail.crt{,.bak}
sudo mv /etc/ssl/private/iRedMail.key{,.bak}
sudo ln -sf /etc/letsencrypt/live/${hostname}/fullchain.pem /etc/ssl/certs/iRedMail.crt
sudo ln -sf  /etc/letsencrypt/live/${hostname}/privkey.pem /etc/ssl/private/iRedMail.key
read -p "Press [Enter] When you are ready to reboot"
sudo reboot

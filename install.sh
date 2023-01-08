#!/bin/bash

echo "Updating and Installing dependencys"
sudo apt update && apt -y upgrade
sudo apt install -y dialog

echo "Installing latest version of iRedMail iRedmail"
rel=$(curl https://github.com/iredmail/iRedMail/tags -s | grep 'tool-tip for="toggle-commit-'| awk '{print substr($3, 20, 5) }')
iRMLATEST=$(echo $rel | awk '{print substr($1, 1) }')
wget "https://github.com/iredmail/iRedMail/archive/refs/tags/${iRMLATEST}.tar.gz"
tar zxf ${iRMLATEST}.tar.gz
cd iRed*
sudo chmod +x iRedMail.sh
rm -rf ../${iRMLATEST}.tar.gz
./iRedmail.sh

echo "Installing SSL certs and rebooting"
hostname=$(hostname -f)
sudo apt install -y certbot python3-certbot-nginx
sudo certbot --nginx -d ${hostname}
sudo mv /etc/ssl/certs/iRedMail.crt{,.bak}
sudo mv /etc/ssl/private/iRedMail.key{,.bak}
sudo ln -sf /etc/letsencrypt/live/mail.flonix.ml/fullchain.pem /etc/ssl/certs/iRedMail.crt
sudo ln -sf  /etc/letsencrypt/live/mail.flonix.ml/privkey.pem /etc/ssl/private/iRedMail.key
reboot

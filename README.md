# iRedMail Simple Installer for Ubuntu and Debian
Easy install Script for iRedMail, should work on any debian based system supporting. For iRedMail - https://www.iredmail.org/

You can use Hetzner to test this with a $20 credit using this referal code https://hetzner.cloud/?ref=p6iUr7jEXmoB

# How to Install the server

Run the following commands:
```
wget https://raw.githubusercontent.com/techahold/iRedMail-Simple/main/install.sh
chmod +x install.sh
./install.sh
```

Been Tested on Debian 11 and Ubuntu 20.04

# Restricting access to admin & sogo webinterface
Under certain circumstances you may want to limit access to the Sogo & Admin interface to certain IP addresses. This can be solved via Nginx templates.

Add the following content to the following files:
allow YOUR-IP;
deny all;

For admin interface:
/etc/nginx/templates -> iredadmin.tmpl
For SoGo Webmail:
/etc/nginx/templates -> sogo.tmpl

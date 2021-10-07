#!/bin/bash
#edit nginx
read -p "What is your website domain name? (EX: mydomain.com)> " domain
echo "In a separate terminal, if you have not already done so, "
echo "Run the following command to get an ssl cert for your domain: "
echo "sudo certbot --nginx -d 'mydomainhere'"
echo ""
echo "press 'c' to continue....."
while : ; do
read -n 1 k <&1
if [[ $k = c ]] ; then
echo ""
printf "Ok then, moving on....."
break
fi
done
clear
#setup nginx
rm -rf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
mv template-ssl/serv.conf /etc/nginx/conf.d/
mv /var/www/html/index.nginx-debian.html /var/www/
sed -i "s+mydomain.dns+$domain+gi" /etc/nginx/conf.d/serv.conf
sed -i "s+mydomain.dns+$domain+gi" chat.html
systemctl restart nginx
echo ""
echo ""
echo ""
read -p "What is the /path/to/chatterbox folder? (EX: /var/www/chatterbox)> " mainloc
clear
echo "If you are not sure, in a separate terminal, run the following:"
echo "sudo certbot certificates"
echo ""
read -p "What it the /path/to/ssl/cert? (EX: /etc/letsencrypt/live/domain/fullhain.pem)> " certloc
read -p "What it the /path/to/ssl/cert? (EX: /etc/letsencrypt/live/domain/privkey.pem)> " keyloc
#main.go public folder edits
echo "Editing public folder paths"
sed -i "s+../public+$mainloc/chat-blue/public+gi" chat-blue/src/main.go
sed -i "s+../public+$mainloc/chat-red/public+gi" chat-red/src/main.go
sed -i "s+../public+$mainloc/chat-green/public+gi" chat-green/src/main.go
sed -i "s+../public+$mainloc/chat-orange/public+gi" chat-orange/src/main.go
sed -i "s+../public+$mainloc/chat-blue-ssl/public+gi" chat-blue-ssl/src/main.go
sed -i "s+../public+$mainloc/chat-red-ssl/public+gi" chat-red-ssl/src/main.go
sed -i "s+../public+$mainloc/chat-green-ssl/public+gi" chat-green-ssl/src/main.go
sed -i "s+../public+$mainloc/chat-orange-ssl/public+gi" chat-orange-ssl/src/main.go
#main.go ssl cert path edits
echo "Editing ssl cert folder paths"
sed -i "s+/full/path/to/cert+$certloc+gi" chat-blue-ssl/src/main.go
sed -i "s+/full/path/to/cert+$certloc+gi" chat-red-ssl/src/main.go
sed -i "s+/full/path/to/cert+$certloc+gi" chat-green-ssl/src/main.go
sed -i "s+/full/path/to/cert+$certloc+gi" chat-orange-ssl/src/main.go
#main.go ssl key path edits
echo "Editing ssl key folder paths"
sed -i "s+/full/path/to/certkey+$keyloc+gi" chat-blue-ssl/src/main.go
sed -i "s+/full/path/to/certkey+$keyloc+gi" chat-red-ssl/src/main.go
sed -i "s+/full/path/to/certkey+$keyloc+gi" chat-green-ssl/src/main.go
sed -i "s+/full/path/to/certkey+$keyloc+gi" chat-orange-ssl/src/main.go
# double check
echo "Have you made the necessary changes to all src/main.go files?"
echo "If not, then you should review the note files in the templates."
echo "press 'Ctrl + c' twice to quit....."
echo "If so, then press 'c' to continue....."
while : ; do
read -n 1 k <&1
if [[ $k = c ]] ; then
echo ""
printf "Ok then, moving on....."
break
fi
done
#build & make services 
echo "building sources and creating services"
sudo cp services/* /etc/systemd/system/
sudo mkdir /opt/chats
sudo go build -o /opt/chats/chat1 chat-blue/src/main.go
sudo go build -o /opt/chats/chat2 chat-red/src/main.go
sudo go build -o /opt/chats/chat3 chat-green/src/main.go
sudo go build -o /opt/chats/chat4 chat-orange/src/main.go
sudo go build -o /opt/chats/chat5 chat-blue-ssl/src/main.go
sudo go build -o /opt/chats/chat6 chat-red-ssl/src/main.go
sudo go build -o /opt/chats/chat7 chat-green-ssl/src/main.go
sudo go build -o /opt/chats/chat8 chat-orange-ssl/src/main.go
sudo systemctl enable chat1
sudo systemctl enable chat2
sudo systemctl enable chat3
sudo systemctl enable chat4
sudo systemctl enable chat5
sudo systemctl enable chat6
sudo systemctl enable chat7
sudo systemctl enable chat8
sudo systemctl start chat1
sudo systemctl start chat2
sudo systemctl start chat3
sudo systemctl start chat4
sudo systemctl start chat5
sudo systemctl start chat6
sudo systemctl start chat7
sudo systemctl start chat8
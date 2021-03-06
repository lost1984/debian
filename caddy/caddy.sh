
#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin; export PATH
# 设置变量
bincaddy=${bincaddy:-https://raw.githubusercontent.com/lost1984/debian/main/caddy/bin/caddy}
configcaddy=${configcaddy:-https://raw.githubusercontent.com/lost1984/debian/main/caddy/etc/caddy.json}
sercaddy=${sercaddy:-https://raw.githubusercontent.com/lost1984/debian/main/caddy/etc/caddy.service}
#安装caddy主程序
wget -O /usr/local/bin/caddy $bincaddy
wget -O -P /usr/local/etc/caddy/caddy.json $configcaddy
 wget -O /etc/systemd/system/caddy.service $sercaddy
 chmod 777 /usr/local/bin/caddy
#添加自启动
systemctl enable caddy && systemctl restart caddy


# 按照需要用的软件
apt update 
apt install -y curl  wegt
bincaddy=${bincaddy:-https://raw.githubusercontent.com/lost1984/debian/master/caddy/bin/caddy}
configcaddy=${configcaddy:-https://raw.githubusercontent.com/lost1984/debian/master/caddy/etc/Caddyfile}
sercaddy=${sercaddy:-https://raw.githubusercontent.com/lost1984/debian/master/caddy/etc/caddy.service}

#安装caddy主程序
caddy_install(){
    # caddyconfig
    wget -O /usr/local/bin/caddy $bincaddy
    wget -O /usr/local/etc/caddy/Caddyfile $configcaddy
    wget -O /etc/systemd/system/caddy.service $sercaddy
    chmod 777 /usr/local/bin/caddy
    #添加自启动
    systemctl enable caddy && systemctl restart caddy 
}

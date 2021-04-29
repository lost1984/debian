#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin; export PATH

# tempfile & rm it when exit
trap 'rm -f "$TMPFILE"' EXIT; TMPFILE=$(mktemp) || exit 1

domain="$2
configxray=${configxray:-https://raw.githubusercontent.com/lost1984/debian/master/xray/etc/xray.json}
configcaddy=${configcaddy:-https://raw.githubusercontent.com/lost1984/debian/master/xray/etc/caddy.json}

########

function install_xray_caddy(){
    # xray
    bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u root
    # caddy -V1
    bash -c "$(curl -L https://github.com/lost1984/caddy.sh)"
}


function config_xray_caddy(){
    # xrayconfig
    wget -O /usr/local/etc/xray/config.json $configxray
    # caddyconfig
    wget -O /usr/local/etc/caddy/Caddyfile $configcaddy
}

function cert_acme(){
    apt install socat -y
    curl https://get.acme.sh | sh && source  ~/.bashrc
    ~/.acme.sh/acme.sh --upgrade --auto-upgrade
    ~/.acme.sh/acme.sh --issue -d $domain --standalone --keylength ec-256 --pre-hook "systemctl stop caddy xray" --post-hook "~/.acme.sh/acme.sh --installcert -d $domain --ecc --fullchain-file /usr/local/etc/xray/$domain.crt --key-file /usr/local/etc/xray/$domain.key --reloadcmd \"systemctl restart caddy xray\""
    ~/.acme.sh/acme.sh --installcert -d $domain --ecc --fullchain-file /usr/local/etc/xray/my.crt --key-file /usr/local/etc/xray/my.key --reloadcmd "systemctl restart xray"
}

function start_info(){
    systemctl enable caddy xray && systemctl restart caddy xray && sleep 3 && systemctl status caddy xray | grep -A 2 "service"
}

main

function main(){
   
    install_xray_caddy
    config_xray_caddy
    cert_acme
    start_info
}

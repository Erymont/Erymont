#!/usr/bin/env bash
set -Eeuo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'
PHP_VERSION='8.3'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cleanup() {
  [[ -n "${TMP_FILE:-}" && -f "${TMP_FILE:-}" ]] && rm -f "$TMP_FILE"
}
trap cleanup EXIT

show_header() {
  clear
  echo -e "${CYAN}${BOLD}=========================================${NC}"
  echo -e "${CYAN}      Erymont Pterodactyl Configurator   ${NC}"
  echo -e "${CYAN}=========================================${NC}"
  echo
}

make_ssl_config() {
  local domain="$1"
  local fullchain="$2"
  local privkey="$3"
  cat > /etc/nginx/sites-available/pterodactyl.conf <<EOF_CONF
server {
    listen 80;
    server_name ${domain};
    return 301 https://\$server_name\$request_uri;
}

server {
    listen 443 ssl http2;
    server_name ${domain};

    root /var/www/pterodactyl/public;
    index index.php;

    ssl_certificate ${fullchain};
    ssl_certificate_key ${privkey};

    client_max_body_size 100m;
    client_body_timeout 120s;
    sendfile off;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php\$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)\$;
        fastcgi_pass unix:/run/php/php${PHP_VERSION}-fpm.sock;
        fastcgi_index index.php;
        include /etc/nginx/fastcgi_params;
        fastcgi_param PHP_VALUE "upload_max_filesize=100M \n post_max_size=100M";
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_intercept_errors off;
        fastcgi_buffer_size 16k;
        fastcgi_buffers 4 16k;
        fastcgi_connect_timeout 300;
        fastcgi_send_timeout 300;
        fastcgi_read_timeout 300;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF_CONF
}

make_http_config() {
  local domain="$1"
  cat > /etc/nginx/sites-available/pterodactyl.conf <<EOF_CONF
server {
    listen 80;
    server_name ${domain};

    root /var/www/pterodactyl/public;
    index index.php;
    charset utf-8;

    client_max_body_size 100m;
    client_body_timeout 120s;
    sendfile off;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php\$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)\$;
        fastcgi_pass unix:/run/php/php${PHP_VERSION}-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param PHP_VALUE "upload_max_filesize=100M \n post_max_size=100M";
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_intercept_errors off;
        fastcgi_buffer_size 16k;
        fastcgi_buffers 4 16k;
        fastcgi_connect_timeout 300;
        fastcgi_send_timeout 300;
        fastcgi_read_timeout 300;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF_CONF
}

show_header

echo -e "${BOLD}Select Configuration Mode:${NC}"
echo -e "  ${GREEN}[1]${NC} SSL / HTTPS"
echo -e "  ${YELLOW}[2]${NC} HTTP / No SSL"
echo -e "  ${YELLOW}[3]${NC} HTTP / HTTPS (custom cert path)"
echo
read -r -p "Select option [1-3]: " OPTION
read -r -p "Enter your Domain (e.g., panel.example.com): " DOMAIN

if [[ -z "$OPTION" || -z "$DOMAIN" ]]; then
  echo -e "${RED}[!] Missing option or domain.${NC}"
  exit 1
fi

cd /var/www/pterodactyl || { echo -e "${RED}[!] Pterodactyl directory not found!${NC}"; exit 1; }
rm -f /etc/nginx/sites-enabled/default /etc/nginx/sites-available/pterodactyl.conf

case "$OPTION" in
  1|3)
    if [[ "$OPTION" == "1" ]]; then
      echo -e "${YELLOW}[*] Selecting SSL profile...${NC}"
      read -r -p "Use Let's Encrypt cert path? [y/N]: " SSLTYPE
    else
      SSLTYPE="y"
    fi

    if [[ "${SSLTYPE,,}" == "y" ]]; then
      FULLCHAIN="/etc/letsencrypt/live/${DOMAIN}/fullchain.pem"
      PRIVKEY="/etc/letsencrypt/live/${DOMAIN}/privkey.pem"
    else
      FULLCHAIN="/etc/certs/panel/fullchain.pem"
      PRIVKEY="/etc/certs/panel/privkey.pem"
    fi

    echo -e "${GREEN}[+] Setting APP_URL to HTTPS...${NC}"
    sed -i "s|APP_URL=.*|APP_URL=https://${DOMAIN}|g" .env
    make_ssl_config "$DOMAIN" "$FULLCHAIN" "$PRIVKEY"
    ;;
  2)
    echo -e "${GREEN}[+] Setting APP_URL to HTTP...${NC}"
    sed -i "s|APP_URL=.*|APP_URL=http://${DOMAIN}|g" .env
    make_http_config "$DOMAIN"
    ;;
  *)
    echo -e "${RED}[!] Invalid option selected.${NC}"
    exit 1
    ;;
esac

ln -sf /etc/nginx/sites-available/pterodactyl.conf /etc/nginx/sites-enabled/pterodactyl.conf

echo -e "${YELLOW}[*] Testing Nginx configuration...${NC}"
if nginx -t; then
  systemctl restart nginx
  echo
  echo -e "${CYAN}=========================================${NC}"
  echo -e "${GREEN}✔ Setup Successfully Completed!${NC}"
  if [[ "$OPTION" == "2" ]]; then
    echo -e "Panel URL: ${BOLD}http://${DOMAIN}${NC}"
  else
    echo -e "Panel URL: ${BOLD}https://${DOMAIN}${NC}"
  fi
  echo -e "${CYAN}=========================================${NC}"
else
  echo
  echo -e "${RED}[!] Nginx configuration failed. Please check errors above.${NC}"
  exit 1
fi

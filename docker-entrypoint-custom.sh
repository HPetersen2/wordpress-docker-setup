#!/bin/bash
set -e

docker-entrypoint.sh apache2-foreground &

echo "Warte auf MySQL..."
until mysqladmin ping -h"${WORDPRESS_DB_HOST}" --silent; do
  sleep 2
done

if ! wp --path=/var/www/html core is-installed --allow-root; then
  echo "Installiere WordPress automatisch ..."

  wp core install \
    --url="${WORDPRESS_URL}" \
    --title="${WORDPRESS_TITLE}" \
    --admin_user="${WORDPRESS_ADMIN_USER}" \
    --admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
    --admin_email="${WORDPRESS_ADMIN_EMAIL}" \
    --skip-email \
    --allow-root
fi

wait

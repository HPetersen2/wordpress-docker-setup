#!/bin/bash
set -e

# Warten auf die MySQL-Datenbank
echo "Warten auf MySQL-Datenbank..."
until nc -z -v -w30 $WORDPRESS_DB_HOST 3306; do
  echo "Warte auf MySQL..."
  sleep 2
done
echo "MySQL ist bereit!"

# Wenn wp-config.php noch nicht existiert, erstelle sie mit den Umgebungsvariablen
if [ ! -f /var/www/html/wp-config.php ]; then
  echo "Erstelle wp-config.php..."

  DB_HOST="${WORDPRESS_DB_HOST:-db}"
  DB_USER="${WORDPRESS_DB_USER:-root}"
  DB_PASSWORD="${WORDPRESS_DB_PASSWORD:-root}"
  DB_NAME="${WORDPRESS_DB_NAME:-wordpress}"
  DB_PREFIX="${WORDPRESS_TABLE_PREFIX:-wp_}"

  AUTH_KEY="${WORDPRESS_AUTH_KEY:-$(openssl rand -base64 32)}"
  SECURE_AUTH_KEY="${WORDPRESS_SECURE_AUTH_KEY:-$(openssl rand -base64 32)}"
  LOGGED_IN_KEY="${WORDPRESS_LOGGED_IN_KEY:-$(openssl rand -base64 32)}"
  NONCE_KEY="${WORDPRESS_NONCE_KEY:-$(openssl rand -base64 32)}"
  AUTH_SALT="${WORDPRESS_AUTH_SALT:-$(openssl rand -base64 32)}"
  SECURE_AUTH_SALT="${WORDPRESS_SECURE_AUTH_SALT:-$(openssl rand -base64 32)}"
  LOGGED_IN_SALT="${WORDPRESS_LOGGED_IN_SALT:-$(openssl rand -base64 32)}"
  NONCE_SALT="${WORDPRESS_NONCE_SALT:-$(openssl rand -base64 32)}"

  WP_DEBUG="${WORDPRESS_DEBUG:-false}"
  CONFIG_EXTRA="${WORDPRESS_CONFIG_EXTRA:-}"

  # Erstelle wp-config.php
  cat <<EOL > /var/www/html/wp-config.php
<?php
// ** MySQL settings - Diese Details müssen für Ihre Installation angepasst werden. ** //
define('DB_NAME', '$DB_NAME');
define('DB_USER', '$DB_USER');
define('DB_PASSWORD', '$DB_PASSWORD');
define('DB_HOST', '$DB_HOST');
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');

// Präfix für die Tabellen in der Datenbank
\$table_prefix = '$DB_PREFIX';

// Sicherheitsschlüssel, Salts und Debugging-Optionen
define('AUTH_KEY', '$AUTH_KEY');
define('SECURE_AUTH_KEY', '$SECURE_AUTH_KEY');
define('LOGGED_IN_KEY', '$LOGGED_IN_KEY');
define('NONCE_KEY', '$NONCE_KEY');
define('AUTH_SALT', '$AUTH_SALT');
define('SECURE_AUTH_SALT', '$SECURE_AUTH_SALT');
define('LOGGED_IN_SALT', '$LOGGED_IN_SALT');
define('NONCE_SALT', '$NONCE_SALT');

// Aktivierung des Debugging-Modus, falls angegeben
if ('$WP_DEBUG' === 'true') {
    define('WP_DEBUG', true);
    define('WP_DEBUG_LOG', true);
    define('WP_DEBUG_DISPLAY', true);
} else {
    define('WP_DEBUG', false);
    define('WP_DEBUG_LOG', false);
    define('WP_DEBUG_DISPLAY', false);
}

// Zusätzliche Konfiguration, falls angegeben
$custom_config = '$CONFIG_EXTRA';
if (!empty($custom_config)) {
    eval($custom_config);
}

// Setzt den WordPress-Abgleich zu den standardmäßigen Optimierungen
if ( ! defined('ABSPATH') )
    define('ABSPATH', dirname(__FILE__) . '/');

// Sets WordPress vars and included files
require_once(ABSPATH . 'wp-settings.php');
EOL

  echo "wp-config.php wurde erfolgreich erstellt."
fi

# Starte den Apache Webserver
echo "Starte Apache..."
exec apache2-foreground

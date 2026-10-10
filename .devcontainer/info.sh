#!/usr/bin/env bash
SITE="${WP_SITE_URL:-http://localhost:8080}"
MAIL="http://localhost:8025"
cat <<MSG

========================================
 WordPress dev environment
========================================
* サイト:       $SITE
* 管理画面:     $SITE/wp-admin (admin / admin)
* メール確認:   $MAIL
* WP-CLI:       コンテナ内のターミナルで \`wpr plugin list\` のように使えます
========================================

MSG

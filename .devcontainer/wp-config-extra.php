<?php
// サイトURLは環境変数 WP_SITE_URL(docker-compose.yml で設定)で決める。
$site_url = getenv( 'WP_SITE_URL' ) ?: 'http://localhost:8080';

define( 'WP_HOME', $site_url );
define( 'WP_SITEURL', $site_url );

define( 'WP_DEBUG_LOG', true );
define( 'WP_DEBUG_DISPLAY', false );
define( 'WP_ENVIRONMENT_TYPE', 'local' );
define( 'FS_METHOD', 'direct' );

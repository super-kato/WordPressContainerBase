#!/usr/bin/env bash
# コンテナ作成後に1回実行される初期化スクリプト。
set -euo pipefail

cd /var/www/html

# 公式イメージのエントリポイントが初回起動時にWordPressコアをコピー
# コピー完了を最大60秒待機(wp-config.phpの作成がコピー完了判定条件)
for _ in $(seq 1 60); do
  [ -f wp-config.php ] && break
  sleep 1
done

# イメージ同梱のデフォルトテーマ/プラグインで未配置のものだけイメージからコピーする
mkdir -p wp-content/uploads
cp -an /usr/src/wordpress/wp-content/. wp-content/
# Apache(www-data)が書き込めるよう、所有者を変更
chown -R www-data:www-data wp-content 2>/dev/null || true

# WP-CLI のラッパーコマンド `wpr` を作成
cat > /usr/local/bin/wpr <<'WPR'
#!/usr/bin/env bash
exec wp --allow-root --path=/var/www/html "$@"
WPR
chmod +x /usr/local/bin/wpr

# 未インストールの場合のみ、WordPress をインストールして初期設定
if ! wpr core is-installed 2>/dev/null; then
  # サイトURLは環境変数 WP_SITE_URL から取得
  # 管理者ユーザを作成
  wpr core install \
    --url="${WP_SITE_URL:-http://localhost:8080}" \
    --title="WordPress Dev" \
    --admin_user=admin \
    --admin_password=admin \
    --admin_email=admin@example.com \
    --skip-email
  wpr language core install ja --activate || true
  wpr option update timezone_string Asia/Tokyo
fi

# Composer の開発用パッケージ(WordPress のスタブなど)を入れる。
if [ -f /workspace/composer.json ]; then
  (cd /workspace && composer install --no-interaction --no-progress)
fi

FROM wordpress:php8.5-apache

RUN apt-get update \
    && apt-get install -y --no-install-recommends git less unzip mariadb-client msmtp-mta \
    && rm -rf /var/lib/apt/lists/*

# Xdebug (off by default; set XDEBUG_MODE=debug to enable)
RUN pecl install xdebug && docker-php-ext-enable xdebug
COPY php-dev.ini /usr/local/etc/php/conf.d/zz-dev.ini

# WP-CLI / Composer
RUN curl -fsSL -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

# Send mail to Mailpit
RUN printf 'account default\nhost mailpit\nport 1025\nfrom wordpress@localhost\n' > /etc/msmtprc

FROM jenkins:latest
# if we want to install via apt
USER root
RUN apt-get update
RUN apt-get install -y apt-transport-https lsb-release ca-certificates
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
RUN "deb https://packages.sury.org/php/ $(lsb_release -sc) main" |  tee /etc/apt/sources.list.d/php.list
RUN apt-get update &&  apt-get install -y php-cli php-xml php-xsl  php-json php-soap php-gmp php-dom \
    php-pdo php-zip php-mysql php-apcu php-mysql php-bcmath php-gd php-odbc \
    php-gettext php-xmlreader php-xmlrpc php-bz2 php-memcache php-iconv php-curl php-ctype php-phar

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN php -r "unlink('composer-setup.php');"
RUn chown -R $USER:$USER ~/.composer/

USER jenkins
RUN composer global config minimum-stability dev && composer global config prefer-stable true
RUN composer global require phpunit/phpunit squizlabs/php_codesniffer \
    phploc/phploc pdepend/pdepend phpmd/phpmd sebastian/phpcpd \
    mayflower/php-codebrowser
RUN export PATH=~/.composer/vendor/bin:$PATH

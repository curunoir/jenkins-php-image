FROM jenkins/jenkins:lts

USER root
RUN apt-get update
RUN apt-get install -y apt-transport-https nano lsb-release ca-certificates
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
#RUN "deb https://packages.sury.org/php/ $(lsb_release -sc) main" |  tee /etc/apt/sources.list.d/php.list
RUN sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'
RUN apt-get update
RUN apt-get install -y php7.2 php7.2-common php7.2-cli php7.2-fpm php7.2-cli php7.2-xml php7.2-xsl \
    php7.2-json php-soap php-gmp php7.2-dom  php7.2-pdo php7.2-zip php7.2-mysql php7.2-apcu php7.2-mysql php7.2-bcmath \
    php7.2-gd php7.2-odb php7.2-gettext php7.2-xmlreader php7.2-xmlrpc php7.2-bz2 php7.2-memcache \
    php7.2-iconv php7.2-curl php7.2-ctype php7.2-phar php7.2.mbstring php7.2-xdebug

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN php -r "unlink('composer-setup.php');"
RUN chown -R $USER:$USER ~/.composer/

USER jenkins
RUN composer global config minimum-stability dev && composer global config prefer-stable true
RUN composer global require phpunit/phpunit squizlabs/php_codesniffer \
    phploc/phploc pdepend/pdepend phpmd/phpmd sebastian/phpcpd \
    mayflower/php-codebrowser
RUN export PATH=~/.composer/vendor/bin:$PATH
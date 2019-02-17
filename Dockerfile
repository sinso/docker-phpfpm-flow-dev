FROM sinso/phpfpm-flow:7.1
MAINTAINER Aslam Idrisov <aslambek.idrisov1@swisscom.com>

# Install nodejs, npm and install latest version of nodejs 
RUN apt-get update \
	&& apt-get install -y \
			gnupg2 \
			 nodejs \
	&& curl -sL https://deb.nodesource.com/setup_11.x | bash - \
	&& apt-get install -y \
	  	   	 npm \
	&& rm -r /var/lib/apt/lists/* \
	&& npm install -g n  \
	&& n stable

		

# install rubygems for compass
RUN apt-get update \
	&& apt-get install -y \
			ruby-dev \
		        rubygems \
	&& rm -r /var/lib/apt/lists/*
			

# install our stuff
RUN \
	npm install -g grunt-cli \
	&& gem install compass \
	&& npm install -g gulp \
	&& npm install -g bower \
	&& npm install -g yo


# install composer
RUN \
    curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

# install fontforge and ttfautohint for grunt-webfont
RUN apt-get update \
	&& apt-get install -y \
		fontforge \
		ttfautohint \
	&& rm -r /var/lib/apt/lists/*

# install xdebug
RUN yes | pecl install xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini

RUN apt-get install --no-install-recommends --assume-yes --quiet ca-certificates curl git &&\
    rm -rf /var/lib/apt/lists/*
RUN curl -Lsf 'https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz' | tar -C '/usr/local' -xvzf -
ENV PATH /usr/local/go/bin:$PATH
RUN go get github.com/mailhog/mhsendmail
RUN cp /root/go/bin/mhsendmail /usr/bin/mhsendmail
RUN echo 'sendmail_path = /usr/bin/mhsendmail --smtp-addr mailhog:1025' >> /usr/local/etc/php/conf.d/php.ini

#libpcre fix
COPY ./assets/libpcre3_8.39-5_amd64.deb /tmp/
RUN dpkg -i /tmp/libpcre3_8.39-5_amd64.deb

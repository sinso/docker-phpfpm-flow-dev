FROM sinso/phpfpm-flow:latest
MAINTAINER Aslam Idrisov <aslambek.idrisov1@swisscom.com>


# Install nodejs, npm and install latest version of nodejs 
RUN apt-get update \
	&& apt-get install -y \
			 nodejs \
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
	npm install -g grunt-cli && \
gem install compass && \
    npm install -g gulp && \
    npm install -g yo


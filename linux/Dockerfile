FROM php:7.4-fpm
WORKDIR /app

COPY . /app

# Install nginx ,supervisor
RUN apt-get update && apt-get install -y \
  supervisor \
  nginx \
  gettext-base \
  libpq-dev \
&& docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
&& docker-php-ext-install pdo_pgsql pgsql
	
#Config nginx, php-fpm, supervisord  
COPY default.conf.template /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/nginx.conf
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
COPY www.conf /usr/local/etc/php-fpm.d/www.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
#Download https://godotengine.org/download/server Server(64-bit)
RUN chmod +x Godot_v3.2.2
ENV PATH="/app/:${PATH}"

CMD ["/usr/bin/supervisord"]
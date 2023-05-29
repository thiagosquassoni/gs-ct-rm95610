FROM ubuntu:latest

# Define a variável de ambiente para evitar interação do usuário
ENV DEBIAN_FRONTEND=noninteractive

# Instala as dependências necessárias
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    apache2 \
    mysql-server \
    php \
    libapache2-mod-php \
    php-mysql \
    php-gd \
    php-curl \
    php-mbstring

# Configura o Apache para o WordPress
RUN a2enmod rewrite
RUN chown -R www-data:www-data /var/www/html/
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Baixa e instala o WordPress
RUN curl -O https://wordpress.org/latest.tar.gz
RUN tar -xzf latest.tar.gz -C /var/www/html/
RUN mv /var/www/html/wordpress/* /var/www/html/
RUN rm -rf /var/www/html/wordpress
RUN chown -R www-data:www-data /var/www/html/
RUN chmod -R 755 /var/www/html/

# Configura o banco de dados para o WordPress
RUN service mysql start && sleep 5 && mysql -e "CREATE DATABASE wordpress; \
    CREATE USER 'wordpress'@'localhost' IDENTIFIED BY 'gsrm95610'; \
    GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost'; \
    FLUSH PRIVILEGES;"

EXPOSE 80

CMD ["apachectl", "-D", "FOREGROUND"]

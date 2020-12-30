FROM debian:buster

RUN apt update && apt install -y nginx vim wget && service nginx start
RUN apt -y install default-mysql-server
RUN apt-get install -y php-mbstring php-zip php-gd php-xml php-pear php-gettext php-cli php-fpm php-cgi php-mysql
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-english.tar.gz 
RUN tar -xzf phpMyAdmin-4.9.0.1-english.tar.gz && rm phpMyAdmin-4.9.0.1-english.tar.gz 
RUN mv phpMyAdmin-4.9.0.1-english/ /var/www/html/ 
RUN mv /var/www/html/phpMyAdmin-4.9.0.1-english/ /var/www/html/phpmyadmin 
RUN mv /var/www/html/phpmyadmin/config.sample.inc.php /var/www/html/phpmyadmin/config.inc.php
COPY ./srcs/config.inc.php /var/www/html/phpmyadmin/config.inc.php
COPY ./srcs/default.conf /etc/nginx/sites-available/default
COPY ./srcs/queries.sql /queries.sql
RUN chmod 777 /var/www/html/ && chown -R www-data:www-data /var/www/html/
RUN service mysql start && mysql -u root < "/queries.sql"
RUN wget -c http://wordpress.org/latest.tar.gz && tar xzf latest.tar.gz
RUN rm latest.tar.gz && mv wordpress /var/www/html/wordpress 
RUN chown -R www-data:www-data /var/www/html/wordpress
RUN chmod -R 755 /var/www//html/wordpress 
COPY ./srcs/self_signed.conf /etc/nginx/snippets/self_signed.conf
COPY ./srcs/ssl_params.conf /etc/nginx/snippets/ssl_params.conf
RUN openssl req -subj "/C=MA/ST=KHOURIBGA/L=BJ/O=Yoki/CN=localhost" -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt
RUN openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
RUN nginx -t
COPY ./srcs/terminator.sh /terminator.sh
RUN chmod 777 /terminator.sh

EXPOSE 80 443
CMD [ "bash", "/terminator.sh" ]
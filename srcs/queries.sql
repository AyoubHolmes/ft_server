GRANT ALL PRIVILEGES ON phpmyadmin.* TO 'user'@'localhost' IDENTIFIED BY '1337';
CREATE DATABASE wordpress;
GRANT ALL ON wordpress.* to 'user'@'localhost' IDENTIFIED BY '1337';
FLUSH PRIVILEGES;

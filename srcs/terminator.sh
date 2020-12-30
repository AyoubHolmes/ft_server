    #!bin/bash

    service nginx restart && service mysql restart && service php7.3-fpm start
    while ((1))
    do
            var_nginx=`service nginx status | grep -c 'not running'`
            var_mysql=`service mysql status | grep -c 'stopped'`
            var_php=`service php7.3-fpm status | grep -c 'not running'`
            if [ $var_nginx -eq 1 ]
            then
                    echo "nginx service stopped"
                    exit
            elif [ $var_mysql -eq 1 ]
            then
                    echo "mysql service stopped"
                    exit
            elif [ $var_php -eq 1 ]
            then
                    echo "php service stopped"
                    exit
            fi
    done
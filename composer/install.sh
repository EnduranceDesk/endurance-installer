echo "***************************************";
echo "*         INSTALLING COMPOSER         *"
echo "***************************************"
EXPECTED_CHECKSUM="$(wget -q -O - https://composer.github.io/installer.sig)"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
then
    >&2 echo 'ERROR: Invalid installer checksum'
    rm composer-setup.php
    exit 1
fi

php composer-setup.php --quiet
RESULT=$?
rm composer-setup.php
echo $RESULT

echo "Moving Composer to /usr/local/bin/composer"
mv composer.phar /usr/local/bin/composer
chmod +x /usr/local/bin/composer
composer -V
echo "***************************************";
echo "*          COMPOSER INSTALLED         *"
echo "***************************************"
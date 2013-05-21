class php-httpd::ubuntu::base
{
    include php, httpd, httpd::config

    # install the package that links PHP to Apache
    package{
        "${php::config::php_prefix}-${php::config::php_version}":
            ensure => installed,
            provider => 'yum',
            require => [
                Yumrepo['ius'],
                Package['re2c'],
                Package['gcc'],
                Package["php-common"],
                Package["php-cli"]
            ],
            alias => 'php',
            notify => Service['httpd'];
    }

    # Make sure that any change to PHP common restarts Apache
    Package["php-common"] ~> Service['httpd']

    File['php-ini'] ~> Service['httpd']
}
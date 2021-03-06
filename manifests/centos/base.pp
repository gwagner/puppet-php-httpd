class php-httpd::centos::base
{
    include php, php::centos::config, httpd, httpd::config

    # install the package that links PHP to Apache
    package{
        "${php::centos::config::php_prefix}-${php::centos::config::php_version}":
            ensure => installed,
            provider => 'yum',
            require => [
                Yumrepo['ius'],
                Package['re2c'],
                Package['gcc'],
                Package["${php::centos::config::php_prefix}-common-${php::centos::config::php_version}"],
                Package["${php::centos::config::php_prefix}-cli-${php::centos::config::php_version}"]
            ],
            alias => 'php',
            notify => Service['httpd'];
    }

    file {
        'php-error-log':
            mode => 770,
            owner => 'apache',
            group => 'apache',
            path => '/var/log/php_errors',
            ensure => present;

        'php-session-dir':
            mode => 770,
            owner => 'apache',
            group => 'apache',
            path => '/var/lib/php/session',
            ensure => directory,
            require => [Package['php']];

        'httpd-php-conf':
            mode => 644,
            owner => "root",
            group => "root",
            path => "/etc/httpd/conf.d/php.conf",
            content => template('php-httpd/centos/php.erb'),
            require => [Package['httpd'], Package['php']];
    }

    # Make sure that any change to PHP common restarts Apache
    Package["${php::centos::config::php_prefix}-common-${php::centos::config::php_version}"] ~> Service['httpd']

    File['php-ini'] ~> Service['httpd']
}
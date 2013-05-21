class php-httpd
{
    case $operatingsystem {
        'RedHat', 'CentOS': { include php-httpd::centos::base }
        'Ubuntu':           { include php-httpd::ubuntu::base }
    }
}
# Define: django::nginx
#
# Parameters
# - The $path contains the path to the project
# - The $package contains the name of the python package in the project
# - The $port contains the port to uwsgi
# - The $domain contains the domain used in `server_name`
# - The $ssl_cert contains the name of the ssl-certificate
# - The $favicon specifies if /favicon.ico should return a file or
#   204 - No content. If it is set to false it will return 204. Default is false

define django::nginx (
  $ssl_cert = '',
  $favicon = false
) {
  file {"${title}.conf":
    path    => "/etc/nginx/sites-enabled/${title}.conf",
    owner   => root,
    group   => root,
    mode    => '0640',
    content => template('nginx.erb'),
    require => Package['nginx'],
    notify  => Package['nginx']
  }
}

$wordpress_path = '/srv/www/wordpress'
$wordpress_user = 'wordpress'
$wordpress_passwd = 'abc123'
$database_name = 'wordpress'
$document_root = '/vagrant'

include apache
include php
include mysql
include wordpress

exec { 'Skip Message':
  command => "echo ‘Este mensaje sólo se muestra si no se ha copiado el fichero index.html'",
  unless => "test -f ${document_root}/index.html",
  path => "/bin:/sbin:/usr/bin:/usr/sbin",
}

$ipv4_address = $facts['networking']['ip']
notify { 'Showing machine Facts':
  message => "Machine with ${::memory['system']['total']} of memory and ${::processorcount} processor/s.
              Please check access to http://${ipv4_address}",
}

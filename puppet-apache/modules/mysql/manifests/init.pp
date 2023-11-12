class mysql {
  package { 'mysql-server':
    ensure => installed,
  }

  class { 'mysql::server':
    user     => $wordpress_user,
    password => $wordpress_passwd,
    host     => 'localhost',
    grant    => ['ALL'],
    require  => Class['mysql::server'],
  }
}

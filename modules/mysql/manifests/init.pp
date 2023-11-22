class mysql {
  package { 'mysql-server':
    ensure => installed,
  }

  service { "mysql":
    enable => true,
    ensure => running,
    require => Package["mysql-server"],
  }

  exec { 'create_mysql_database':
    command => "/usr/bin/mysql -u root -p -e 'CREATE DATABASE ${database_name};'",
    path    => ['/usr/bin', '/bin'],
  }

  exec { 'create_mysql_user':
    command => "/usr/bin/mysql -u root -p -e \"CREATE USER '${wordpress_user}'@'localhost' IDENTIFIED BY '${wordpress_passwd}';\"",
    path    => ['/usr/bin', '/bin'],
    unless  => "/usr/bin/mysql -u root -p -e \"SELECT User FROM mysql.user WHERE User='${wordpress_user}' AND Host='localhost';\" | grep ${wordpress_user}",
  }


  exec { 'grant_mysql_privileges':
    command => "/usr/bin/mysql -u root -p -e \"GRANT ALL PRIVILEGES ON ${wordpress_user}.* TO '${wordpress_user}'@'localhost';\"",
    path    => ['/usr/bin', '/bin'],
    require => Exec['create_mysql_user'],
  }


  exec { 'flush_mysql_privileges':
    command => "/usr/bin/mysql -u root -p -e 'FLUSH PRIVILEGES;'",
    path    => ['/usr/bin', '/bin'],
  }

}

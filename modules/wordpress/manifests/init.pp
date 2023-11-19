class wordpress {
  require mysql

  $wordpress_owner = 'www-data'
  $wordpress_url = 'https://wordpress.org/latest.tar.gz'
  $wordpress_path = '/srv/www/wordpress'
  $config_file = '/srv/www/wordpress/wp-config.php'

  file { '/srv/www':
    ensure => 'directory',
    owner  => $wordpress_owner,
    group  => $wordpress_owner,
    mode   => '0755',
  }

  file { $wordpress_path:
    ensure  => directory,
    owner   => $wordpress_owner,
    group   => $wordpress_owner,
    mode    => '0755',
    recurse => true,
    purge   => true,
  }

  exec { 'download_wordpress':
    command     => "/usr/bin/wget -O '${wordpress_path}/wordpress.tar.gz' '${wordpress_url}'",
  }

  exec { 'extract_wordpress':
    command     => "/bin/tar -zxvf '${wordpress_path}/wordpress.tar.gz' -C '${wordpress_path}' --strip-components=1",
    user        => $wordpress_owner,
    require     => Exec['download_wordpress'],
  }

  file { $config_file:
    ensure  => present,
    content => template('wordpress/wp-config.php.j2'),
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0644',    
  }

  $settings = {
    'localhost' => {
      ensure        => 'latest',
      wproot        => $wordpress_path,
      owner         => 'wp',
      dbhost        => 'localhost',
      dbname        => $database_name,
      dbuser        => $wordpress_user,
      dbpasswd      => $wordpress_passwd,
      wpadminuser   => 'admin',
      wpadminpasswd => 'admin',
      wpadminemail  => 'webmaster@localhost',
      wptitle       => 'the title is to deploy WordPress with puppet',
    }
  }
}

class apache {
  exec { 'apt-update':
    command => '/usr/bin/apt-get update'
  }
  Exec["apt-update"] -> Package <| |>

  package { 'apache2':
    ensure => installed,
  }

  file { '/etc/apache2/sites-enabled/000-default.conf':
    ensure => absent,
    require => Package['apache2'],
  }

  file { '/etc/apache2/sites-available/vagrant.conf':
    content => template('apache/virtual-hosts.conf.erb'),
    require => File['/etc/apache2/sites-enabled/000-default.conf'],
  }

  file { "/etc/apache2/sites-enabled/vagrant.conf":
    ensure  => link,
    target  => "/etc/apache2/sites-available/vagrant.conf",
    require => File['/etc/apache2/sites-available/vagrant.conf'],
    notify  => Service['apache2'],
  }

  file { "${wordpress_path}/index.html":
    ensure  => present,
    source => 'puppet:///modules/apache/index.html',
    require => File['/etc/apache2/sites-enabled/vagrant.conf'],
    notify  => Service['apache2'],
  }

  exec { 'enable_wordpress_site':
    command     => 'a2ensite wordpress',
    refreshonly => true,
  }

  exec { 'enable_rewrite_module':
    command     => 'a2enmod rewrite',
    refreshonly => true,
  }

  service { 'apache2':
    ensure => running,
    enable => true,
    restart => "/usr/sbin/apachectl configtest && /usr/sbin/service apache2 reload",
  }

  file { "${wordpress_path}":
    ensure => directory,
    recurse => true,
    mode => '0755',
  }

}


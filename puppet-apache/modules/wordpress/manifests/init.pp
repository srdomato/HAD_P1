$wordpress_owner = 'www-data'
$config_file = '/srv/www/wordpress/wp-config.php'

class wordpress {
  file { '/srv/www':
    ensure => 'directory',
    owner  => $wordpress_owner,
    group  => $wordpress_owner,
    mode   => '0755',
  }

  archive { 'wordpress':
    ensure       => present,
    source       => 'https://wordpress.org/latest.tar.gz',
    path         => '/srv/www',
    extract      => true,
    extract_path => '/srv/www',
    creates      => '/srv/www/wordpress',
    cleanup      => true,
    user         => $wordpress_owner,
    group        => $wordpress_owner,
  }

  file { $config_file:
    ensure => present,
    source => '/srv/www/wordpress/wp-config-sample.php',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0644',
  }

  augeas { 'wordpress_database_name':
    context => "/files${config_file}/",
    changes => [
      "set define('DB_NAME', '${database_name}')",
    ],
    require => File[$config_file],
  }

  augeas { 'wordpress_username':
    context => "/files${config_file}/",
    changes => [
      "set define('DB_USER', '${wordpress_user}')",
    ],
    require => Augeas['wordpress_database_name'],
  }

  augeas { 'wordpress_password':
    context => "/files${config_file}/",
    changes => [
      "set define('DB_PASSWORD', '${wordpress_passwd}')",
    ],
    require => Augeas['wordpress_username'],
  }

  augeas { 'replace_salt_lines':
    context => "/files${config_file}/",
    changes => [
      "set define('AUTH_KEY', ') ZV+0?#_TE%St0j.5![EU>k`ZzB=2eTj6}ko+ EO}X)[WKJ.AAxe`VqYQ+kzK2.')",
      "set define('SECURE_AUTH_KEY', 'k a*2uuLVnP*:cKHUHwO[lkI_Zc,Jg~4~QRN}9/)M%Avb:i*-vIn%Jums.}IIKak')",
      "set define('LOGGED_IN_KEY', 'eB]2@+Pn*UK>`08+tTE=a}tJ*_vxh+dWf30p?KQyV,<Q+>B+;*ddu7i9DQs}F?c3')",
      "set define('NONCE_KEY', '%$5T[+g9GnSS2;GCdriB$.~([^8O/+wADRBI8qr<!x72ERnNnN?_TaLU]z+v~I`k')",
      "set define('AUTH_SALT', 'p,{1t>ZO7>dO)m,vQE&?|i@<gI2= Z8mzG(yq1?-_gOC2H!QnM8(TseQ[fL+ -,*')",
      "set define('SECURE_AUTH_SALT', '..Lbc]QMR&>DJ94V!#+GI.m[5=e5(&*kM:u}YHWJcPO8iUc4Q?!m;@=-`+0iXOi(')",
      "set define('LOGGED_IN_SALT', '^GagXh6zsyi?BEgofTPpF$1]*s]RRe(asm3as+dv[+V#1}AUB-^ZhQj+<Fsx^b:`')",
      "set define('NONCE_SALT', 'K QN?(Z+>HGV|-DCe+ag+qJ%wle,e:.b&NjLvz>LTRAV1EG;c:j1M]jDL73gH{Nv')",
    ],
    require => File[$config_file],
  }

  settings => {
    'localhost' => {
      ensure        => 'latest',
      wproot        => ${wordpress_path},
      owner         => 'wp',
      dbhost        => 'localhost',
      dbname        => ${database_name},
      dbuser        => ${wordpress_user},
      dbpasswd      => ${wordpress_passwd},
      wpadminuser   => 'admin',
      wpadminpasswd => 'admin',
      wpadminemail  => 'webmaster@localhost',
      wptitle       => 'the title is to deploy WordPress with puppet',
    }
  }

}

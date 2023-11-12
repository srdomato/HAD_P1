class php {
  package { ['ghostscript', 'php', 'libapache2-mod-php', 'php-mysql', 'php-bcmath', 'php-curl', 'php-imagick', 'php-intl', 'php-json', 'php-mbstring', 'php-xml', 'php-zip']:
    ensure => installed,
  }
}

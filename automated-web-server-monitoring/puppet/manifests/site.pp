# Puppet manifest: site.pp
# Responsibility: Enforce Nginx package, service, and baseline configuration state.
# Zero-conflict guarantee: Static website content (/var/www/html/index.html & style.css)
# is strictly owned and deployed by Ansible.

node default {
  # 1. Ensure Nginx package is installed
  package { 'nginx':
    ensure => installed,
  }

  # 2. Ensure the Nginx service is running and enabled on boot
  service { 'nginx':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['nginx'],
  }

  # 3. Ensure document root directory exists with proper permissions
  file { '/var/www/html':
    ensure  => directory,
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0755',
    require => Package['nginx'],
  }
}


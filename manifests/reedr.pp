exec {'/usr/bin/apt-get update': }
->
package { 'apache2':
    ensure => present,
}
->
package {
  "mysql-client":
    ensure  => present;
  "php5-mysql":
    ensure  => present;
  "php5-cli":
    ensure => present;
  "libapache2-mod-php5":
    ensure => present;
}
->
file { '/etc/apache2/sites-available/default':
    ensure => present,
    source => '/vagrant/config/apache-default-site',
}
->
file { '/etc/apache2/sites-enabled/000-default':
    ensure => link,
    target => '/etc/apache2/sites-available/default',
}
->
exec { 'remove old httpd root':
    command => '/bin/rm -rf /var/www',
}
->
exec { 'link httpd root':
    command => '/bin/ln -fs /vagrant/app /var/www',
}
->
file { '/etc/apache2/mods-enabled/rewrite.load':
    ensure => link,
    target => '/etc/apache2/mods-available/rewrite.load',
}
->
service { 'apache2':
    ensure     => running,
    enable     => true,
    subscribe  => File['/etc/apache2/sites-available/default'],
}

package { "mysql-server":
  ensure => present,
}
->
service { "mysql":
  enable => true,
  ensure => running,
}
->
exec { "set-mysql-password":
  unless => "mysqladmin -uroot -proot status",
  path => ["/bin", "/usr/bin"],
  command => "mysqladmin -uroot password root",
}
->
exec { "create db":
  unless => "mysql -uroot -proot reedr",
  path => ["/bin", "/usr/bin"],
  command => "mysqladmin -uroot -proot create reedr",
}
->
exec { "create schema":
  unless => "php /vagrant/bin/doctrine-cli.php orm:validate-schema",
  path => ["/bin", "/usr/bin"],
  command => "php /vagrant/bin/doctrine-cli.php orm:schema-tool:create",
}

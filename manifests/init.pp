# = Class: stoplight
#
# == Parameters:
#
# [*ruby_version*]
#   The ruby version to use.
#
# == Example:
#
#   class { 'stoplight':
#     ruby_version => '1.9.3-p194'
#   }
#
class stoplight(
  $ruby_version
) {

  package { ['make', 'g++']:
    ensure   => latest,
  }

  user { 'stoplight':
    ensure     => present,
    managehome => true,
  }

  rvm::system_user {
    'stoplight': ;
  }

  rvm_gem {
    "bundler-${ruby_version}":
      name          => 'bundler',
      ruby_version  => $ruby_version,
      ensure        => present,
      require       => Rvm_system_ruby[$ruby_version];
  }

  rvm_gem {
    "rack-${ruby_version}":
      name          => 'rack',
      ruby_version  => $ruby_version,
      ensure        => present,
      require       => Rvm_system_ruby[$ruby_version];
  }

  exec { 'stoplight-install-git':
    command => 'git clone git://github.com/customink/stoplight.git',
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    cwd     => '/home/stoplight',
    user    => 'stoplight',
    unless  => 'test -d /home/stoplight/stoplight',
    require => [
      Package['git-core'],
      User['stoplight']
    ],
  }

  concat { '/home/stoplight/stoplight/config/servers.yml':
    owner   => 'stoplight',
    group   => 'stoplight',
    alias   => 'stoplight-config-servers',
    require => Exec['stoplight-install-git'],
  }

  exec { 'stoplight-install-bundler':
    command => "rvm --with-rubies ${ruby_version} do bundle install",
    path    => '/usr/local/rvm/bin:/usr/bin:/bin:/usr/sbin:/sbin',
    cwd     => '/home/stoplight/stoplight',
    user    => 'stoplight',
    unless  => 'test -f /home/stoplight/stoplight/config/servers.yml',
    require => [
      Exec['stoplight-install-git'],
      Package['make', 'g++'],
      Rvm_gem["bundler-${ruby_version}"]
    ],
  }

  exec { 'stoplight-run':
    command => "rvm --with-rubies ${ruby_version} do rackup ./config.ru &",
    path    => '/usr/local/rvm/bin:/usr/bin:/bin:/usr/sbin:/sbin',
    cwd     => '/home/stoplight/stoplight',
    user    => 'stoplight',
    unless  => 'curl http://127.0.0.1:9292',
    require => [
      Exec['stoplight-install-bundler'],
      Concat['stoplight-config-servers'],
      Rvm_gem["rack-${ruby_version}"]
    ],
  }
}

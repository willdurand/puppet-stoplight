# = Class: stoplight
#
# == Parameters:
#
# [*ruby_version*]
#   The ruby version to use.
#
# [*user*]
#   The user who runs the application.
#   Default: stoplight
#
# == Example:
#
#   class { 'stoplight':
#     ruby_version => '1.9.3-p194'
#   }
#
class stoplight(
  $ruby_version = 'UNDEF',
  $user         = 'UNDEF'
) {

  include stoplight::params

  if $ruby_version == 'UNDEF' {
    $sl_ruby_version = $stoplight::params::ruby_version
  } else {
    $sl_ruby_version = $ruby_version
  }

  if $user == 'UNDEF' {
    $sl_user = $stoplight::params::user
  } else {
    $sl_user = $user
  }

  if ! defined(User[$sl_user]) {
    user { $sl_user:
      ensure     => present,
      managehome => true,
    }

    rvm::system_user {
      $sl_user: ;
    }
  }

  rvm_gem {
    "bundler-${sl_ruby_version}":
      ensure        => present,
      name          => 'bundler',
      ruby_version  => $sl_ruby_version,
      require       => Rvm_system_ruby[$sl_ruby_version];
  }

  rvm_gem {
    "rack-${sl_ruby_version}":
      ensure        => present,
      name          => 'rack',
      ruby_version  => $sl_ruby_version,
      require       => Rvm_system_ruby[$sl_ruby_version];
  }

  exec { 'stoplight-install-git':
    command => 'git clone git://github.com/customink/stoplight.git',
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    cwd     => "/home/${sl_user}",
    user    => $sl_user,
    unless  => "test -d /home/${sl_user}/stoplight",
    require => [
      Package['git'],
      User['stoplight']
    ],
  }

  concat { 'stoplight-servers':
    path    => "/home/${sl_user}/stoplight/config/servers.yml",
    owner   => $sl_user,
    group   => $sl_user,
    require => Exec['stoplight-install-git'],
  }

  exec { 'stoplight-install-bundler':
    command => "rvm --with-rubies ${sl_ruby_version} do bundle install",
    path    => '/usr/local/rvm/bin:/usr/bin:/bin:/usr/sbin:/sbin',
    cwd     => "/home/${sl_user}/stoplight",
    user    => $sl_user,
    unless  => "test -f /home/${sl_user}/stoplight/config/servers.yml",
    require => [
      Exec['stoplight-install-git'],
      Rvm_gem["bundler-${sl_ruby_version}"]
    ],
  }

  exec { 'stoplight-run':
    command => "rvm --with-rubies ${sl_ruby_version} do rackup ./config.ru &",
    path    => '/usr/local/rvm/bin:/usr/bin:/bin:/usr/sbin:/sbin',
    cwd     => "/home/${sl_user}/stoplight",
    user    => $sl_user,
    unless  => 'curl http://127.0.0.1:9292',
    require => [
      Exec['stoplight-install-bundler'],
      Concat['stoplight-servers'],
      Rvm_gem["rack-${sl_ruby_version}"]
    ],
  }
}

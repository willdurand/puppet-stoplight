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
# [*create_user*]
#   Whether to create the user.
#
# == Example:
#
#   class { 'stoplight':
#     ruby_version => '1.9.3-p194'
#   }
#
class stoplight(
  $ruby_version,
  $user           = $stoplight::params::user,
  $create_user    = true,
) inherits stoplight::params {

  if $create_user {
    user { $user:
      ensure     => present,
      managehome => true,
    }

    rvm::system_user {
      $user: ;
    }
  }

  rvm_gem {
    "bundler-${ruby_version}":
      ensure        => present,
      name          => 'bundler',
      ruby_version  => $ruby_version,
      require       => Rvm_system_ruby[$ruby_version];
  }

  rvm_gem {
    "rack-${ruby_version}":
      ensure        => present,
      name          => 'rack',
      ruby_version  => $ruby_version,
      require       => Rvm_system_ruby[$ruby_version];
  }

  exec { 'stoplight-install-git':
    command => 'git clone git://github.com/customink/stoplight.git',
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    cwd     => "/home/${user}",
    user    => $user,
    unless  => "test -d /home/${user}/stoplight",
    require => [
      Package['git'],
      User['stoplight']
    ],
  }

  concat { "/home/${user}/stoplight/config/servers.yml":
    owner   => $user,
    group   => $user,
    alias   => 'stoplight-config-servers',
    require => Exec['stoplight-install-git'],
  }

  exec { 'stoplight-install-bundler':
    command => "rvm --with-rubies ${ruby_version} do bundle install",
    path    => '/usr/local/rvm/bin:/usr/bin:/bin:/usr/sbin:/sbin',
    cwd     => "/home/${user}/stoplight",
    user    => $user,
    unless  => "test -f /home/${user}/stoplight/config/servers.yml",
    require => [
      Exec['stoplight-install-git'],
      Rvm_gem["bundler-${ruby_version}"]
    ],
  }

  exec { 'stoplight-run':
    command => "rvm --with-rubies ${ruby_version} do rackup ./config.ru &",
    path    => '/usr/local/rvm/bin:/usr/bin:/bin:/usr/sbin:/sbin',
    cwd     => "/home/${user}/stoplight",
    user    => $user,
    unless  => 'curl http://127.0.0.1:9292',
    require => [
      Exec['stoplight-install-bundler'],
      Concat['stoplight-config-servers'],
      Rvm_gem["rack-${ruby_version}"]
    ],
  }
}

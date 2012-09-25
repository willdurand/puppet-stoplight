# = Define: stoplight::server
#
# == Parameters:
#
# [*provider*]
#   A provider name.
#
# [*url*]
#   URL to the CI server.
#   Default: $name
#
# [*projects*]
#   A list of projects to include.
#   Regular expressions supported.
#
# [*ignored_projects*]
#   A list of projects to ignore.
#   Regular expressions supported.
#
# == Example:
#
#   stoplight::server { 'server-name':
#     provider => 'jenkins',
#     url      => 'http://example.com:8080/',
#   }
#
define stoplight::server(
  $provider,
  $url              = $name,
  $projects         = false,
  $ignored_projects = false
) {

  include stoplight

  concat::fragment { "stoplight-server-${name}":
    target  => 'stoplight-servers',
    content => template('stoplight/servers.yml.erb'),
  }
}

# = Define: stoplight::project
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
#   stoplight::project { 'project-name':
#     provider => 'jenkins',
#     url      => 'http://example.com:8080/',
#   }
#
define stoplight::project(
  $provider,
  $url              = $name,
  $projects         = [],
  $ignored_projects = []
) {

  concat::fragment { "stoplight-project-${name}":
    target  => '/home/stoplight/stoplight/config/servers.yml',
    content => template('stoplight/servers.yml.erb'),
  }
}

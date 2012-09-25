# = Class: stoplight
#
# This class defines default parameters used by the main module class stoplight.
# Operating Systems differences in names and paths are addressed here.
#
# == Variables:
#
# Refer to stoplight class for the variables defined here.
#
# == Usage:
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes.
#
class stoplight::params {
  $ruby_version = '1.9.3-p194'
  $user         = 'stoplight'
}

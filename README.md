puppet-stoplight
================

[![Build
Status](https://secure.travis-ci.org/willdurand/puppet-stoplight.png)](http://travis-ci.org/willdurand/puppet-stoplight)

This module manages [Stoplight](https://github.com/customink/stoplight), a
powerful build monitoring tool.

Installation
------------

This module depends on:

* [puppet-concat](https://github.com/ripienaar/puppet-concat);
* [puppet-rvm](https://github.com/blt04/puppet-rvm).

Get the modules above, and that one by cloning it:

    git clone git://github.com/willdurand/puppet-stoplight.git modules/stoplight


USAGE - Basic management
------------------------

First of all, you need a working Ruby environment:

    class {
      'rvm': ;
    }

    rvm_system_ruby { '1.9.3-p194':
      ensure      => present,
      default_use => false,
    }

You also need `git`, `g++` and `make`.

Now you can install **Stoplight** using this Ruby version:

    class { 'stoplight':
      ruby_version => '1.9.3-p194'
    }


USAGE - Managing servers
-------------------------

Configuring a new server into **Stoplight** is really easy, just add the
following lines to your configuration:

    stoplight::server { 'propel':
      provider => 'jenkins',
      url      => 'http://ci.propelorm.org',
    }

    stoplight::server { 'http://127.0.0.1:8080':
      provider         => 'jenkins',
      ignored_projects => [ '/-deploy$/', '/-package$/' ],
    }

Availables parameters are: `provider`, `url`, `projects` and `ignored_projects`.


Running the tests
-----------------

Install the dependencies using [Bundler](http://gembundler.com):

    BUNDLE_GEMFILE=.gemfile bundle install

Run the following command:

    BUNDLE_GEMFILE=.gemfile bundle exec rake spec


License
-------

puppet-stoplight is released under the MIT License. See the bundled LICENSE file for details.

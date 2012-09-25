require 'spec_helper'

describe 'stoplight', :type => :class do
  let(:title) { 'stoplight' }
  let(:facts) { {
    :concat_basedir => '/var/lib/puppet/concat',
  } }

  describe 'Test standard installation' do
    it { should contain_user('stoplight') }
    it { should contain_rvm_gem('bundler-1.9.3-p194') }
    it { should contain_rvm_gem('rack-1.9.3-p194') }
    it { should contain_exec('stoplight-install-git') \
      .with_user('stoplight')
    }
    it { should contain_exec('stoplight-install-bundler')\
      .with_command('rvm --with-rubies 1.9.3-p194 do bundle install') \
      .with_user('stoplight')
    }
    it { should contain_exec('stoplight-run') \
      .with_command('rvm --with-rubies 1.9.3-p194 do rackup ./config.ru &') \
      .with_user('stoplight')
    }
    it { should contain_concat('stoplight-config-servers') }
  end

  describe 'Test standard installation with given ruby_version' do
    let(:params) { {:ruby_version => '1.9.3' } }

    it { should contain_user('stoplight') }
    it { should contain_rvm_gem('bundler-1.9.3') }
    it { should contain_rvm_gem('rack-1.9.3') }
    it { should contain_exec('stoplight-install-git') \
      .with_user('stoplight')
    }
    it { should contain_exec('stoplight-install-bundler') \
      .with_command('rvm --with-rubies 1.9.3 do bundle install') \
      .with_user('stoplight')
    }
    it { should contain_exec('stoplight-run') \
      .with_command('rvm --with-rubies 1.9.3 do rackup ./config.ru &') \
      .with_user('stoplight')
    }
    it { should contain_concat('stoplight-config-servers') }
  end

  describe 'Test standard installation with given user' do
    let(:params) { {:user => 'foo' } }

    it { should contain_user('foo') }
    it { should contain_rvm_gem('bundler-1.9.3-p194') }
    it { should contain_rvm_gem('rack-1.9.3-p194') }
    it { should contain_exec('stoplight-install-git') \
      .with_user('foo')
    }
    it { should contain_exec('stoplight-install-bundler') \
      .with_command('rvm --with-rubies 1.9.3-p194 do bundle install') \
      .with_user('foo')
    }
    it { should contain_exec('stoplight-run') \
      .with_command('rvm --with-rubies 1.9.3-p194 do rackup ./config.ru &') \
      .with_user('foo')
    }
    it { should contain_concat('stoplight-config-servers') }
  end
end

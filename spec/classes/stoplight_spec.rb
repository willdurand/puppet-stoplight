require 'spec_helper'

describe 'stoplight', :type => :class do
  let(:title) { 'stoplight' }
  let(:facts) { {
    :concat_basedir => '/var/lib/puppet/concat',
  } }

  describe 'Test another standard installation' do
    let(:params) { {:ruby_version => '1.9.3-p194' } }

    it { should contain_user('stoplight') }
    it { should contain_rvm_gem('bundler-1.9.3-p194') }
    it { should contain_rvm_gem('rack-1.9.3-p194') }
    it { should contain_exec('stoplight-install-git') }
    it { should contain_exec('stoplight-install-bundler').with_command('rvm --with-rubies 1.9.3-p194 do bundle install') }
    it { should contain_exec('stoplight-run').with_command('rvm --with-rubies 1.9.3-p194 do rackup ./config.ru &') }
    it { should contain_concat('stoplight-config-servers') }
  end
end

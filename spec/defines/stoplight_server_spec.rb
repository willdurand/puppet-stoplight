require 'spec_helper'

describe 'stoplight::server', :type => :define do
  let(:title) { 'stoplight::server' }
  let(:facts) { {
    :concat_basedir => '/var/lib/puppet/concat',
  } }

  describe 'Test stoplight::server with basic parameters' do
    let(:params) { {
      :name     => 'jenkins-ci',
      :provider => 'jenkins',
      :url      => 'http://localhost:8080'
    } }

    it { should contain_concat__fragment('stoplight-server-jenkins-ci') \
      .with_content("-\n  type: jenkins\n  url: http://localhost:8080\n\n")
    }
  end

  describe 'Test stoplight::server without url' do
    let(:params) { {
      :name     => 'http://localhost:8080',
      :provider => 'jenkins',
    } }

    it { should contain_concat__fragment('stoplight-server-http://localhost:8080') \
      .with_content("-\n  type: jenkins\n  url: http://localhost:8080\n\n")
    }
  end

  describe 'Test stoplight::server with projects' do
    let(:params) { {
      :name     => 'jenkins-ci',
      :provider => 'jenkins',
      :url      => 'http://localhost:8080',
      :projects => [ 'foo', '/^bar' ]
    } }

    it { should contain_concat__fragment('stoplight-server-jenkins-ci') \
      .with_content("-\n  type: jenkins\n  url: http://localhost:8080\n  projects:\n    - foo\n    - /^bar\n\n")
    }
  end

  describe 'Test stoplight::server with ignored projects' do
    let(:params) { {
      :name             => 'jenkins-ci',
      :provider         => 'jenkins',
      :url              => 'http://localhost:8080',
      :ignored_projects => [ 'foo', 'bar' ]
    } }

    it { should contain_concat__fragment('stoplight-server-jenkins-ci') \
      .with_content("-\n  type: jenkins\n  url: http://localhost:8080\n  ignored_projects:\n    - foo\n    - bar\n\n")
    }
  end

  describe 'Test stoplight::server with both projects and ignored projects' do
    let(:params) { {
      :name             => 'jenkins-ci',
      :provider         => 'jenkins',
      :url              => 'http://localhost:8080',
      :projects         => [ 'baz' ],
      :ignored_projects => [ 'foo', 'bar' ]
    } }

    it { should contain_concat__fragment('stoplight-server-jenkins-ci') \
      .with_content("-\n  type: jenkins\n  url: http://localhost:8080\n  projects:\n    - baz\n  ignored_projects:\n    - foo\n    - bar\n\n")
    }
  end
end

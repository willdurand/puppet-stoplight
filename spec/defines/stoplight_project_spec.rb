require 'spec_helper'

describe 'stoplight::project', :type => :define do
  let(:title) { 'stoplight::project' }
  let(:facts) { {
    :concat_basedir => '/var/lib/puppet/concat',
  } }

  describe 'Test stoplight::project with basic parameters' do
    let(:params) { {
      :name     => 'jenkins-ci',
      :provider => 'jenkins',
      :url      => 'http://localhost:8080'
    } }

    it { should contain_concat__fragment('stoplight-project-jenkins-ci') \
      .with_content("-\n  type: jenkins\n  url: http://localhost:8080\n\n")
    }
  end

  describe 'Test stoplight::project without url' do
    let(:params) { {
      :name     => 'http://localhost:8080',
      :provider => 'jenkins',
    } }

    it { should contain_concat__fragment('stoplight-project-http://localhost:8080') \
      .with_content("-\n  type: jenkins\n  url: http://localhost:8080\n\n")
    }
  end

  describe 'Test stoplight::project with projects' do
    let(:params) { {
      :name     => 'jenkins-ci',
      :provider => 'jenkins',
      :url      => 'http://localhost:8080',
      :projects => [ 'foo', '/^bar' ]
    } }

    it { should contain_concat__fragment('stoplight-project-jenkins-ci') \
      .with_content("-\n  type: jenkins\n  url: http://localhost:8080\n  projects:\n    - foo\n    - /^bar\n\n")
    }
  end

  describe 'Test stoplight::project with ignored projects' do
    let(:params) { {
      :name             => 'jenkins-ci',
      :provider         => 'jenkins',
      :url              => 'http://localhost:8080',
      :ignored_projects => [ 'foo', 'bar' ]
    } }

    it { should contain_concat__fragment('stoplight-project-jenkins-ci') \
      .with_content("-\n  type: jenkins\n  url: http://localhost:8080\n  ignored_projects:\n    - foo\n    - bar\n\n")
    }
  end

  describe 'Test stoplight::project with both projects and ignored projects' do
    let(:params) { {
      :name             => 'jenkins-ci',
      :provider         => 'jenkins',
      :url              => 'http://localhost:8080',
      :projects         => [ 'baz' ],
      :ignored_projects => [ 'foo', 'bar' ]
    } }

    it { should contain_concat__fragment('stoplight-project-jenkins-ci') \
      .with_content("-\n  type: jenkins\n  url: http://localhost:8080\n  projects:\n    - baz\n  ignored_projects:\n    - foo\n    - bar\n\n")
    }
  end
end

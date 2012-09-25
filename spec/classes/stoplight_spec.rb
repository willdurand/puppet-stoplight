require 'spec_helper'

describe 'stoplight' do
  let(:title) { 'stoplight' }

  describe 'Test standard installation' do
    let(:params) { {:ruby_version => '1.9.3' } }
    it { should contain_package('make').with_ensure('present') }
  end
end

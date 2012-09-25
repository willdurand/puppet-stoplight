require 'spec_helper'

describe 'stoplight' do
  let(:title) { 'stoplight' }

  describe 'Test standard installation' do
    it { should contain_file('servers.yml').with_ensure('present') }
  end
end

require 'rake'
require 'rspec/core/rake_task'
require 'puppet-lint/tasks/puppet-lint'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = ["--format", "doc", "--color"]
  t.pattern    = 'spec/*/*_spec.rb'
end

task :test    => [:spec, :lint]
task :default => :test

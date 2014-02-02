require 'rspec/core'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = FileList['spec/*_spec.rb']
end

desc "Run tests"
task :default => :spec
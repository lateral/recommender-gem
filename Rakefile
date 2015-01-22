require 'rspec/core/rake_task'
require 'yard'
require 'bundler/gem_tasks'

# Run with `rake spec`
RSpec::Core::RakeTask.new(:spec) do |task|
  task.rspec_opts = ['--color', '--format', 'd', '--fail-fast', '--tty']
end

YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb']
end

task default: :spec

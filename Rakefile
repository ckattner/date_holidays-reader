# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

require 'rubocop/rake_task'
RuboCop::RakeTask.new

task default: %i[rubocop spec]

CLOBBER.include(%w[pkg node_bin])

desc 'Compile the Node dependencies'
task :node_compile do
  sh 'yarn run pkg bin/holidays-to-json.js --out-path=node_bin --targets=macos-x64,linux-x64'
end

# Add node_compile as a dependency to the existing build task defined by bundler:
task build: :node_compile
